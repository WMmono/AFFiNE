use std::time::SystemTime;

use affine_common::hashcash::Stamp;
use affine_nbstore::storage;

use crate::error::UniffiError;

mod error;

uniffi::setup_scaffolding!("affine_mobile_native");

#[uniffi::export]
pub fn hashcash_mint(resource: String, bits: u32) -> String {
  Stamp::mint(resource, Some(bits)).format()
}

#[derive(uniffi::Record)]
pub struct DocRecord {
  pub doc_id: String,
  pub data: Vec<u8>,
  pub timestamp: SystemTime,
}

impl From<affine_nbstore::DocRecord> for DocRecord {
  fn from(record: affine_nbstore::DocRecord) -> Self {
    Self {
      doc_id: record.doc_id,
      data: record.data,
      timestamp: record.timestamp.and_utc().into(),
    }
  }
}

impl From<DocRecord> for affine_nbstore::DocRecord {
  fn from(record: DocRecord) -> Self {
    Self {
      doc_id: record.doc_id,
      data: record.data,
      timestamp: chrono::DateTime::<chrono::Utc>::from(record.timestamp).naive_utc(),
    }
  }
}

#[derive(uniffi::Record)]
pub struct DocUpdate {
  pub doc_id: String,
  pub created_at: SystemTime,
  pub data: Vec<u8>,
}

impl From<affine_nbstore::DocUpdate> for DocUpdate {
  fn from(update: affine_nbstore::DocUpdate) -> Self {
    Self {
      doc_id: update.doc_id,
      created_at: update.created_at.and_utc().into(),
      data: update.data,
    }
  }
}

impl From<DocUpdate> for affine_nbstore::DocUpdate {
  fn from(update: DocUpdate) -> Self {
    Self {
      doc_id: update.doc_id,
      created_at: chrono::DateTime::<chrono::Utc>::from(update.created_at).naive_utc(),
      data: update.data.into(),
    }
  }
}

#[derive(uniffi::Record)]
pub struct DocClock {
  pub doc_id: String,
  pub timestamp: SystemTime,
}

impl From<affine_nbstore::DocClock> for DocClock {
  fn from(clock: affine_nbstore::DocClock) -> Self {
    Self {
      doc_id: clock.doc_id,
      timestamp: clock.timestamp.and_utc().into(),
    }
  }
}

impl From<DocClock> for affine_nbstore::DocClock {
  fn from(clock: DocClock) -> Self {
    Self {
      doc_id: clock.doc_id,
      timestamp: chrono::DateTime::<chrono::Utc>::from(clock.timestamp).naive_utc(),
    }
  }
}

#[derive(uniffi::Object)]
pub struct DocStorage {
  storage: storage::SqliteDocStorage,
}

#[uniffi::export]
impl DocStorage {
  #[uniffi::constructor]
  pub fn new(path: String) -> Result<Self, UniffiError> {
    if path.is_empty() {
      return Err(UniffiError::EmptyDocStoragePath);
    }
    Ok(Self {
      storage: storage::SqliteDocStorage::new(path),
    })
  }

  /// Initialize the database and run migrations.
  pub async fn connect(&self) -> Result<(), UniffiError> {
    Ok(self.storage.connect().await?)
  }

  pub async fn close(&self) -> Result<(), UniffiError> {
    Ok(self.storage.close().await)
  }

  pub fn is_closed(&self) -> bool {
    self.storage.is_closed()
  }

  pub async fn checkpoint(&self) -> Result<(), UniffiError> {
    Ok(self.storage.checkpoint().await?)
  }

  pub async fn validate(&self) -> Result<bool, UniffiError> {
    Ok(self.storage.validate().await?)
  }

  pub async fn set_space_id(&self, space_id: String) -> Result<(), UniffiError> {
    if space_id.is_empty() {
      return Err(UniffiError::EmptySpaceId);
    }
    Ok(self.storage.set_space_id(space_id).await?)
  }

  pub async fn push_update(
    &self,
    doc_id: String,
    update: Vec<u8>,
  ) -> Result<SystemTime, UniffiError> {
    Ok(
      self
        .storage
        .push_update(doc_id, update)
        .await?
        .and_utc()
        .into(),
    )
  }

  pub async fn get_doc_snapshot(&self, doc_id: String) -> Result<Option<DocRecord>, UniffiError> {
    Ok(self.storage.get_doc_snapshot(doc_id).await?.map(Into::into))
  }

  pub async fn set_doc_snapshot(&self, snapshot: DocRecord) -> Result<bool, UniffiError> {
    Ok(self.storage.set_doc_snapshot(snapshot.into()).await?)
  }

  pub async fn get_doc_updates(&self, doc_id: String) -> Result<Vec<DocUpdate>, UniffiError> {
    Ok(
      self
        .storage
        .get_doc_updates(doc_id)
        .await?
        .into_iter()
        .map(Into::into)
        .collect(),
    )
  }

  pub async fn mark_updates_merged(
    &self,
    doc_id: String,
    updates: Vec<SystemTime>,
  ) -> Result<u32, UniffiError> {
    Ok(
      self
        .storage
        .mark_updates_merged(
          doc_id,
          updates
            .into_iter()
            .map(|t| chrono::DateTime::<chrono::Utc>::from(t).naive_utc())
            .collect(),
        )
        .await?,
    )
  }

  pub async fn delete_doc(&self, doc_id: String) -> Result<(), UniffiError> {
    Ok(self.storage.delete_doc(doc_id).await?)
  }

  pub async fn get_doc_clocks(
    &self,
    after: Option<SystemTime>,
  ) -> Result<Vec<DocClock>, UniffiError> {
    Ok(
      self
        .storage
        .get_doc_clocks(after.map(|t| chrono::DateTime::<chrono::Utc>::from(t).naive_utc()))
        .await?
        .into_iter()
        .map(Into::into)
        .collect(),
    )
  }

  pub async fn get_doc_clock(&self, doc_id: String) -> Result<Option<DocClock>, UniffiError> {
    Ok(self.storage.get_doc_clock(doc_id).await?.map(Into::into))
  }
}
