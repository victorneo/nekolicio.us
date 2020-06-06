---
title: "ASGI Frameworks for Python Are Here"
date: 2020-06-07T01:01:00+08:00
draft: false
description: "Time for ASGI Web Frameworks for Python"
---

## ASGI, WSGI, and Python

Most popular Python web frameworks, such as Django and Flask, works wth WSGI
(Web Server Gateway Interface) under the hood, which has been around since
[PEP 333][1] in 2003, and its update [PEP 3333][2] in 2010.

With the introduction of asyncio in Python 3 and `await` syntax in Python 3.5,
the Python community finally has an easy way to do asynchronous programming. It
was only a matter of time before steam would pick up for asynchronous support
for web frameworks in the form of [ASGI][3] (Asynchronous Server Gateway
Interface).

Major web frameworks are currently working to go async, including [Django][4],
which is a major effort itself given the size of the framework. [Flask][5],
which uses [Werkzeug][6] interally, does not have ASGI support yet.

If you are building a new Python-based web project today, the new of ASGI web
frameworks should be on your list for consideration; they "generally" perform
faster than their WSGI-only counterparts for the same workload, and while
[benchmarks][7] are helpful, it is still best to benchmark it against your own
use cases.

![TechEmpower Benchmarks Round 19](/images/asgi/benchmarks.png)
<center>_[TechEmpower Benchmarks Round 19][7]: <br />ASGI-based web frameworks perform
much better than their WSGI-only counterparts_</center>

## Try an ASGI-Supported Web Framework Today

**If you are looking for a Django-like experience** for a full web framework,
[FastAPI][9] would offer the closest experience. There's full support for
[Pydantic][10], which makes the experience more pure Python than to learn a new
framework-specific API.

![FastAPI Logo](/images/asgi/fastapi.png)
<center>_[FastAPI][9] is your best choice for a full web framework_</center>

**If you are looking for a Flask-like experience** for a micro-web framework,
you will be spoiled for options.

- [Quart][11] offers full-API compatibility with Flask, and should be the
  first place where you start
- [Vibora][12] has an API inspired by Flask with an obsession for speed
- [Sanic][13] is also inspired by Flask but has different design decisions from
  Vibora


```
from quart import Quart

app = Quart(__name__)

@app.route('/')
async def hello():
    return 'hello'

app.run()
```
<center>_Quart's [Hello World Example][14]_</center>

**If you are looking for an ASGI framework/toolkit**, [Starlette][15] will be the
one to go for. It is lower level than the ones listed above as it is ultimately
a toolkit, but you might find it useful for developing your own frameworks.
[Starlette-Starter][16] is a boilerplate that I have built for my own API
projects, which might be helpful for you if you are looking for a starting
point for your own frameworks.

![Starlette Logo](/images/asgi/starlette.png)
<center>_[Starlette, an ASGI Framework / Toolkit][14]_</center>


If you try any of the frameworks above, I wil be happy to hear more about your
explorations with them on [Twitter][17].


[1]: https://www.python.org/dev/peps/pep-0333/
[2]: https://www.python.org/dev/peps/pep-3333/
[3]: https://asgi.readthedocs.io/en/latest/specs/main.html
[4]: https://docs.djangoproject.com/en/dev/releases/3.1/
[5]: https://flask.palletsprojects.com/en/1.1.x/
[6]: https://github.com/pallets/werkzeug/issues/1322#issuecomment-601062396
[7]: https://www.techempower.com/benchmarks/#section=data-r19&hw=cl&test=composite&l=zijzen-1r
[8]: https://www.uvicorn.org/
[9]: https://fastapi.tiangolo.com/
[10]: https://fastapi.tiangolo.com/features/#just-modern-python
[11]: https://pgjones.gitlab.io/quart/index.html
[12]: https://vibora.io/
[13]: https://sanic.readthedocs.io/en/latest/
[14]: https://pgjones.gitlab.io/quart/tutorials/quickstart.html
[15]: https://www.starlette.io/
[16]: https://github.com/victorneo/starlette-starter
[17]: https://twitter.com/victorneo
