# Semi-automatic nuclei template generator

Usage:
`./generator.sh wordlistfile payloadfile`

To build your own wordlistfile, check out this workflow by our friend [nullenc0de](https://twitter.com/nullenc0de/status/1423973855941509124) and pay special attention to the api_params.txt which gets created on the 3rd line:
```
wget https://gist.githubusercontent.com/nullenc0de/bb16be959686295b3b1caff519cc3e05/raw/2016dc0e692821ec045edd5ae5c0aba5ec9ec3f1/api-linkfinder.yaml
echo https://stripe.com/docs/api | hakrawler | nuclei -t ./api-linkfinder.yaml -o api.txt
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
* Add error handling



Please open an issue if you encounter a bug, have a suggestion, comment, or idea. Feel free to open a pull request if you want to fix a bug or make an improvement of your own. \m/

# Disclaimer
* You agree, by downloading this software, to use it at your own risk and to only use it for educational purposes. 
* This project is not affiliated with, nor endorsed by, [Project Discovery](https://github.com/projectdiscovery).
