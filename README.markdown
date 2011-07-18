#Cockpit

Cockpit is a light weight Ruby wrapper for the Github v3 api. It was inspired by the Github v2 Ruby wrapper octopi.

##Credits

* Corey Collins
* JP Richardson

##Install

Cockpit can easily be installed as a Ruby gem:

    $ [sudo] gem install cockpit

##Usage

To use cockpit just include it in your script:

    require 'cockpit'

    include Cockpit

###Authenicated

If you have genereated a access token through github, then you can use the authenicated api with this method:

    authenicated do
      repo = Repository.find('private-repo')
    end

###Anonymous

Otherwise, if you are not authenticated there is no need to wrap your method call in the block. Like:

    repo = Repository.find('public-repo')


## API Completed

This is still a work in progress and not all of the api has been mapped yet. So far these have been mapped.

**1. Users**
**2. Repos**
**3. Git Data**
***a. Blobs***
***b. Commits***
***c. Tags***
***d. Trees***
***d. References***

##License

Copyright (c) 2011, Gitpilot LLC

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
