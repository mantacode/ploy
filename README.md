# ploy

## Usage

```
$ ploy publish [.ploy-publish.yml]
$ ploy receive /etc/ploy-receiver.yaml
$ ploy receive /etc/ploy-receiver.yaml single-deployment
$ ploy oracle /path/to/metadata.d
$ ploy bless $bucket $deploy $branch $version
```

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

### ploy-receiver.yml

```
---
bucket: bucketname
metadata_dir: /etc/ploy-metadata
deployments:
 - some-project
 - another-project
 - a-third-project

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
