export interface NbStorePlugin {
  create: (options: { path: string }) => Promise<void>;
  connect: () => Promise<void>;
  close: () => Promise<void>;
  isClosed: () => Promise<{ isClosed: boolean }>;
  checkpoint: () => Promise<void>;
  validate: () => Promise<{ isValidate: boolean }>;

  setSpaceId: (options: { spaceId: string }) => Promise<void>;
  pushUpdate: (options: {
    docId: string;
    data: Uint8Array;
  }) => Promise<{ timestamp: number }>;
  getDocSnapshot: (options: { docId: string }) => Promise<
    | {
        docId: string;
        data: Uint8Array;
        timestamp: number;
      }
    | undefined
  >;
  setDocSnapshot: (options: {
    docId: string;
    data: Uint8Array;
  }) => Promise<{ success: boolean }>;
  getDocUpdates: (options: { docId: string }) => Promise<
    {
      docId: string;
      createdAt: number;
      data: Uint8Array;
    }[]
  >;
  markUpdatesMerged: (options: {
    docId: string;
    timestamps: number[];
  }) => Promise<{ count: number }>;
  deleteDoc: (options: { docId: string }) => Promise<void>;
  getDocClocks: () => Promise<
    {
      docId: string;
      timestamp: number;
    }[]
  >;
  getDocClock: (options: { docId: string }) => Promise<
    | {
        docId: string;
        timestamp: number;
      }
    | undefined
  >;
}
