import { existsSync, statSync } from 'node:fs';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';

export class Path {
  static dir(url: string) {
    return new Path(join(fileURLToPath(url), '..'));
  }

  get value() {
    return this.path;
  }

  get relativePath() {
    return './' + this.path.slice(ProjectRoot.path.length);
  }

  constructor(public readonly path: string) {}

  join(...paths: string[]) {
    return new Path(join(this.path, ...paths));
  }

  toString() {
    return this.path;
  }

  exists() {
    return existsSync(this.path);
  }

  stats() {
    return statSync(this.path);
  }

  isFile() {
    return this.exists() && this.stats().isFile();
  }

  isDirectory() {
    return this.exists() && this.stats().isDirectory();
  }
}

export const ProjectRoot = Path.dir(import.meta.url).join('../../../');
