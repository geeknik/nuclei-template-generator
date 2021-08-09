Please note that generator.sh is not quite ready for public consumption. A brave few have been chosen as guinea pigs to beta test and help with bug fixes. Stay tuned.

# nuclei-template-tools
Tools that make creating templates for nuclei even easier.

# Automatic nuclei template generator
Usage:
`./generator.sh wordlistfile payloadfile`

To build your own wordlistfile, check out this workflow by our friend [nullenc0de](https://twitter.com/nullenc0de/) and pay special attention to the api_params.txt which gets created on the 3rd line:
```
wget https://gist.githubusercontent.com/nullenc0de/bb16be959686295b3b1caff519cc3e05/raw/2016dc0e692821ec045edd5ae5c0aba5ec9ec3f1/api-linkfinder.yaml
echo https://stripe.com/docs/api | hakrawler -t 500 -d 10 | nuclei -t ./api-linkfinder.yaml -o api.txt
cat api.txt | grep url_params | cut -d ' ' -f 7 |tr , '\n' | tr ] '\n' | tr [ '\n' |tr -d '"' | tr -d "'" | sort -u > api_params.txt
cat api.txt | grep relative_links | cut -d ' ' -f 7 |tr , '\n' | tr ] '\n' | tr [ '\n' | tr -d '"' | tr -d "'" | sort -u > api_link_finder.txt
```

Be creative! Use your own custom built wordlists! Play with different payloads! You're limited only by your imagination. Good luck out there! \m/


# FIXED
* Generated templates now validate as long as the payloadfile is properly escaped or encoded 🥳

# TODO
* Add support for Raw, Network and File templates
* Add `unsafe` option.
* Add support for multiple matchers
* Add support for status matchers
* Better support for multiple payloads
