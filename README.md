mco-openstack-backup
====================

This project aims backup Openstack instances using MCollective.

Mcollective `fsfreeze` agent
------------------------------

The Mcollective `fsfreeze` agent allows to freeze and unfreeze filesystems using MCollective.

Current caveat: `/tmp` cannot be frozen, as it freezes MCollective itself.

