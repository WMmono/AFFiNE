use thiserror::Error;

#[derive(uniffi::Error, Error, Debug)]
pub enum UniffiError {
  #[error("Empty doc storage path")]
  EmptyDocStoragePath,
  #[error("Empty space id")]
  EmptySpaceId,
  #[error("Sqlx error: {0}")]
  SqlxError(String),
}

impl From<sqlx::Error> for UniffiError {
  fn from(err: sqlx::Error) -> Self {
    UniffiError::SqlxError(err.to_string())
  }
}
