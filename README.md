# CLI (thor based) Image Fetcher
> CLI is implemented with [Thor](https://github.com/erikhuda/thor)

 
### How to:
```bash
# install gems
>> bundle install

# run cli to find the commands
>> thor cli

=> Commands:
   thor cli:download         # download from the SOURCE file.
   thor cli:download_single  # download single URL.
   thor cli:help [COMMAND]   # Describe available commands or one specific command
   thor cli:say_hello        # test it.

# run tests:
>> rspec spec/
```

### Commands:
- **download** Download url from the file. `SOURCE, DEST` params required.

`usage: thor cli:help download`. 

- **download_single** Download single url. `URL, DEST` params required.

`usage: thor cli:help download_single`.

- **say_hello** Just say hello to service 

`usage: thor cli:help say_hello`.
