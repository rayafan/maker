ifndef REVISION_SHA
REVISION_SHA=$(shell $(call git_revision))
endif

export REVISION_SHA