---
title: "ActivityPub: Part 1"
date: 2020-05-10T01:01:00+08:00
draft: false
description: "Federating with ActivityPub: Part 1"
---

## Let's Federate on ActivityPub

ActivityPub is a [protocol for decentralized social networks][1] to that allows
federation - imagine servers running their own instances of "Twitter" that can
speak with each other, across domains.

The screenshot below shows a toots and its replies on [Mastodon][2], a
Twitter-like social network that supports ActivityPub with users across
different servers:

![Toot from Mastodon](/images/actpub/toot-example.png)
<center>_[Example of a toot from Mastodon][3]_</center>

Supporting users across federated platforms introduces some interesting
problems: posting updates, following / unfollowing users.

In this series of blog posts, I will be documenting my journey in building a
simple server that federates with ActivityPub servers. It will be a fun journey
to figure out how other implementations work and learn about the fun / pain
when operating a federated application.

If you are interested in learning more, it might be easier (and faster) to
check out existing implementations (next section) or check out
[activitypub.rocks][4].

## Existing Implementations

[Fediverse.party][5] documents a list of decentralized social platforms, some
of which are not ActivityPub compatible (eg. the once wildly popular
[Disapora][6]).

The most popular ActivityPub federated network would be [Mastodon][2], which
became popular when ActivityPub received the W3C Recommendation status. You
will have to choose which instances of Mastodon to join though. I am
[@victorneo@mastodon.social][23] if you want to follow me - my toots are
automatically posted to my Twitter as well.

![Toot from Mastodon](/images/actpub/mastodon-instances.png)
<center>_Some Mastodon Instances you can join_</center>

Some others include [Pleroma][7], [write.as][8], and [MissKey][9] which is very
popular with Japanese users.

## Implementation

The [Guide for new ActivityPub implementators][10] is the best place to start
right and what I will follow, and where you should start if you are ever
implementing your own. [ActivityPub as it has been understood][11] is another
good reference with some good references.

Unfortunately, the official test suite has been [down for a while][12] and will
continue to be for a while, but fortunately a [new one is in the works][13].
For testing purposes at the moment, we will attempt to federate with Mastodon
and its ActivityPub implementation.


![Testsuite](/images/actpub/testsuite-status.png)
<center>_Yikes, not a good sign with the official test suite is down. Fortunately, a [new one][13] is in the works._</center>

You can follow my progress on this repository: [soda-hub/Soda][14]. There's currently
only one or two working API endpoints for testing out how Following APIs work.

For the Python folks reading this, I am using [Starlette][21] to build the
application to also take this chance to play with a ASGI framework using
asyncio on Python 3. It's been refreshing so far to be able to use asyncio
with a Flask-inspired API for building web applications, and with the nice
[performance benefits][22] that comes with it.

## Let's Begin: Let's Follow Someone

The [official website][4] has a reference image for a really high-level
overview of how Federation works for ActivityPub:

![ActivityPub Overview](/images/actpub/actpub-overview.png)
<center>_High-level Overview of ActivityPub_</center>

Most interactions between servers that Federate would be over the `/inbox`
endpoint - except for the initial user discovery. Here is a quick sequence of
interactions when I search for a user on a remote server to follow on Mastodon:

1. Server A sends a [webfinger][15] request to the remote server (Server B) to
  identify the user
2. Server B replies with the user's information
3. Server A shows the user's information, and thumbnail
4. Server A sends a follow request to Server B when a user clicks Follow to the
  user's `/inbox` address
5. Server B replies with an Follow object to indicate that following is approved

![Mastodon User Search](/images/actpub/mastodon-search.png)
<center>_Mastodon User Search UI_</center>

In terms of HTTP endpoints involved in the same flow:

1. Server A: `HTTP GET https://serverb.com/.well-known/webfinger?resource=acct:username@serverb.com`
2. Server A: `HTTP GET https://serverb.com/(some url)/username` with the header `Accept: application/activity+json`
3. Server B replies with the user's information
4. Server A shows the user's information, and thumbnail
5. Server A sends a follow request to Server B: `HTTP POST https://serverb.com/(some url)/username/inbox`


The webfinger request returns the following response from Mastodon when I query
for my own account:

```
{
  "subject":"acct:victorneo@mastodon.social",
  "aliases":[
    "https://mastodon.social/@victorneo",
    "https://mastodon.social/users/victorneo"
  ],
  "links":[
    {
      "rel":"http://webfinger.net/rel/profile-page",
      "type":"text/html",
      "href":"https://mastodon.social/@victorneo"
    },
    {
      "rel":"self",
      "type":"application/activity+json",
      "href":"https://mastodon.social/users/victorneo"
    },
    {
      "rel":"http://ostatus.org/schema/1.0/subscribe",
      "template":"https://mastodon.social/authorize_interaction?uri={uri}"
    }
  ]
}
```

After getting this response, any server would know that they can access my
profile information by looking for the link that points to `self` and
of the `application/activity+json` type.

Querying the endpoint (with HTTP header `Accept: application/activity+json`),
you will get the following response:

```
{  "@context":["https://www.w3.org/ns/activitystreams", ,,,],
  "id":"https://mastodon.social/users/victorneo",
  "type":"Person",
  "following":"https://mastodon.social/users/victorneo/following",
  "followers":"https://mastodon.social/users/victorneo/followers",
  "inbox":"https://mastodon.social/users/victorneo/inbox",
  "outbox":"https://mastodon.social/users/victorneo/outbox",
  "featured":"https://mastodon.social/users/victorneo/collections/featured",
  "preferredUsername":"victorneo",
  "name":"Victor Neo",
  "summary":"\u003cp\u003eEngineering at Carousell. Passionate about the Open 🕸️.\u003c/p\u003e",
  "url":"https://mastodon.social/@victorneo",
  "manuallyApprovesFollowers":false,
  "discoverable":true,
  "publicKey":{
    "id":"https://mastodon.social/users/victorneo#main-key",
    "owner":"https://mastodon.social/users/victorneo",
    "publicKeyPem":"-----BEGIN PUBLIC KEY-----\...\n-----END PUBLIC KEY-----\n"
  },
  "tag":[],
  "attachment":[],
  "endpoints":{
    "sharedInbox":"https://mastodon.social/inbox"
  },
  "icon":{
    "type":"Image",
    "mediaType":"image/jpeg",
    "url":"https://files.mastodon.social/accounts/avatars/000/077/572/original/a79a3b7bf7011af0.jpg"

  }
}
```

Parsing the response, another server can send a [Follow request][16] to
`https://mastodon.social/users/victorneo/inbox` to be processed.


## Key Format

There's no "official" format when it comes down specifying the public key
encoding format that should be used when generated (see [this issue][17]).

Mastodon's [mini-tutorial][18] on setting up a compatible ActivityPub
implementation indicates that they use a 2048 bits key using OpenSSL in the
terminal... which I assume that they use a library internally for.

As I am using Python for building my app, I will be using
[pyca/cryptography][19] to help me with key generation for my application. You
can view the [key generation code][20] here, but definitely do not use it
without reading the documentation on what it does as (i) I am not a security
expert, and (ii) this is not production grade security configuration.


## Next Up

In the next series, we will continue with the Follow interactions, and get a
proper `/inbox` endpoint up and going.


[1]: https://www.w3.org/TR/activitypub/
[2]: https://joinmastodon.org/
[3]: https://mastodon.social/web/statuses/104126966908663803
[4]: https://activitypub.rocks/
[5]: https://fediverse.party/
[6]: https://diasporafoundation.org/
[7]: https://pleroma.social/
[8]: https://write.as/
[9]: https://join.misskey.page/en/
[10]: https://socialhub.activitypub.rocks/t/guide-for-new-activitypub-implementers/479
[11]: https://flak.tedunangst.com/post/ActivityPub-as-it-has-been-understood
[12]: https://socialhub.activitypub.rocks/t/the-activitypub-test-suite/290
[13]: https://socialhub.activitypub.rocks/t/introducing-fedidb-devtools-for-activitypub/660
[14]: https://github.com/Soda-Hub/soda
[15]: https://docs.joinmastodon.org/spec/webfinger/
[16]: https://flak.tedunangst.com/post/AP-networking
[17]: https://github.com/w3c/activitypub/issues/315
[18]: https://blog.joinmastodon.org/2018/06/how-to-implement-a-basic-activitypub-server/
[19]: https://cryptography.io/en/latest/hazmat/primitives/asymmetric/rsa/
[20]: https://github.com/Soda-Hub/soda/blob/master/models/crypto_utils.py#L22
[21]: https://www.starlette.io/
[22]: https://www.techempower.com/benchmarks/#section=data-r17&hw=ph&test=fortune&l=zijzen-1
[23]: https://mastodon.social/@victorneo
