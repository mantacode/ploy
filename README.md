# ploy

[![Build Status](https://magnum.travis-ci.com/mantacode/ploy.png?token=x2pVeg6qmsxSFb6xKLh7&branch=master)](https://magnum.travis-ci.com/mantacode/ploy)

Deployment tools.

Tests -> Publish -> Expensive Tests -> Bless

Loosely couples build and deploy steps.

Intended for pull, rather than push, model.

Written in Ruby, compiles as a Ruby Gem.

Produces .deb packages, so currently only useful for deploying to Debian/Ubuntu-like
systems.

## Why

We have a bunch of different services. All of them need to be tested separately, then
tested together, then put into production. Along the way, many different testing or
QA environments might need to run them.  Ploy provides facilities for making that 
easy.

## Usage

```
$ ploy help [command]
$ ploy publish [.ploy-publish.yml]
$ ploy oracle /path/to/metadata.d
$ ploy install -b BUCKET -d DEPLOYMENT [-B BRANCH] [-v VERSION]
$ ploy bless -b BUCKET -d DEPLOYMENT -B BRANCH -v VERSION
$ ploy bless -b BUCKET -f INFO_FILE
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

## Intended workflow

 1. A user pushes code to github
 2. A CI server (e.g. Travis) runs tests
 3. If the tests pass, the CI server calls "ploy publish" to publish the build
 4. Some test environment is polling for new builds with "ploy install", and
    advertising available versions with "ploy oracle"
 5. A smoke test server is watching for changes in the report from "ploy oracle"
 6. When changes happen, it runs more tests
 7. If the tests pass, it calls "ploy bless"
 8. Production selects only from blessed builds

## Development

Improvements welcome. Error handling is minimal. Tests are thin in spots. Not
much code documentation (yet).

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

### Legal

Ploy was created by [Manta Media Inc](http://www.manta.com/), a web company in 
Columbus, Ohio. It is distributed under the MIT license.
