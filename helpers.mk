define git_version
    git describe --tags --match=[0-9].[0-9].[0-9]* --abbrev=0
endef

define git_revision
    git describe --tag --long
endef

define git_sha
    git rev-parse HEAD
endef

define git_current_branch
    git branch | grep \* | cut -d ' ' -f2
endef