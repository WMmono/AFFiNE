import { readFileSync } from 'node:fs';
import { parse } from 'node:path';

import { type Path, ProjectRoot } from './path';
import type { CommonPackageJsonContent, YarnWorkspaceItem } from './types';
import type { Workspace } from './workspace';
import type { PackageName } from './workspace.gen';

export function readPackageJson(path: Path): CommonPackageJsonContent {
  const content = readFileSync(path.join('package.json').toString(), 'utf-8');

  return JSON.parse(content);
}

export class Package {
  readonly name: PackageName;
  readonly packageJson: CommonPackageJsonContent;
  readonly dirname: string;
  readonly path: Path;
  readonly srcPath: Path;
  readonly nodeModulesPath: Path;
  readonly tsbuildPath: Path;
  readonly distPath: Path;
  readonly version: string;
  readonly isTsProject: boolean;
  readonly workspaceDependencies: string[];
  readonly deps: Package[] = [];

  get entry() {
    return this.packageJson.main || this.packageJson.exports?.['.'];
  }

  constructor(
    public readonly workspace: Workspace,
    meta: YarnWorkspaceItem
  ) {
    const { location: relativePath, name, workspaceDependencies } = meta;
    // TODO: check [mismatchedWorkspaceDependencies]

    this.name = name as PackageName;

    // parse paths
    this.path = ProjectRoot.join(relativePath);
    this.dirname = parse(relativePath).name;
    this.srcPath = this.path.join('src');
    this.tsbuildPath = this.path.join('tsbuild');
    this.distPath = this.path.join('dist');
    this.nodeModulesPath = this.path.join('node_modules');

    // parse workspace
    const packageJson = readPackageJson(this.path);
    this.packageJson = packageJson;
    this.version = packageJson.version;
    this.workspaceDependencies = workspaceDependencies;
    this.isTsProject = this.path.join('tsconfig.json').isFile();
  }

  get scripts() {
    return this.packageJson.scripts || {};
  }

  join(...paths: string[]) {
    return this.path.join(...paths);
  }
}
