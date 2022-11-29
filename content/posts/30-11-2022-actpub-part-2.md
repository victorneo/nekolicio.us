---
title: "ActivityPub: Part 2"
date: 2022-11-30T01:01:00+08:00
draft: false
description: "Federating with ActivityPub: Part 2"
---

## 2 Years Ago...

I finally got back with a new blog post 2 years since my initial experiments
with the ActivityPub protocol.

Fortunately, the protocol has pretty much remained the same. The good news is
that since two years ago, there are better and newer resources to kickstart the
process of building an implementation.


## ActivityPub Tutorial

One super useful resource that I have found is Timothy's
[activity-pub-tutorial][1]. It describes the minimal implementation required
for an ActivityPub implementation to talk to other servers.

Notably, it includes a section on Mastodon's new `digest` requirement which bit
me when I was messing around with my own implementation two years ago...

Following this tutorial is probably the best and fastest way to get started.

## Side Note on Digest Header

Mastodon requires the `digest` header which caught my off-guard two years back.

Instead of simply signing this signature text:
```
(request-target): post %s\nhost: %s\ndate: %s
```

It is now

```
(request-target): post %s\ndigest: SHA-256=%s\nhost: %s\ndate: %s'
```

Timothy's tutorial includes instructions on how to implement it this new requirement,
so you can follow it as you go along.



[1]: https://github.com/timmot/activity-pub-tutorial
