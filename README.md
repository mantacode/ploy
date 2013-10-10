# ploy

[![Build Status](https://magnum.travis-ci.com/mantacode/ploy.png?token=x2pVeg6qmsxSFb6xKLh7&branch=master)](https://magnum.travis-ci.com/mantacode/ploy)

Deployment tools.

Tests -> Publish -> Expensive Tests -> Bless

Loosely couples build and deploy steps.

Intended for pull, rather than push, model.

Written in ruby, compiles as a ruby gem.

## Usage

```
$ ploy help [command]
$ ploy publish [.ploy-publish.yml]
$ ploy oracle /path/to/metadata.d
$ ploy install -b BUCKET -d DEPLOYMENT [-B BRANCH] [-v VERSION]
$ ploy bless -b BUCKET -d DEPLOYMENT -B BRANCH -v VERSION
```

The 'help' command actually works, so you should definitely use that.

### .ploy-publish.yml

```
---
bucket: bucketname
deploy_name: some-project
dist_dir: dist
prep_cmd: lineman build
upstart_files:
 - conf/some-project-initfile
```

### metadata files

```
---
name: some-project
sha: 67e4c66509f6ab1672f0b02f527a23c39a7937bc
github_url: http://github.com/org/some-project
git_url: git@github.com:org/some-project
last_committer: Bob Bobson <bob@example.com>

```

## Development

Improvements welcome. Error handling is minimal. Tests are thin in spots.

### Run Tests

```
$ rspec spec
```

### Build gem file

```
$ gem build ploy.gemspec
```

## Requirements

 - ruby 1.9+
 - fpm
 - rsync
 - dpkg (for tests)

Known to work on OSX and Ubuntu.


