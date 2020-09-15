# Changing configuration

After deploying Squid Cache with ICAP connected, you may need to tweak some configuration

Mainly, you may need to modify

- **Protected domains** : Domains that should be protected with Glasswall Rebuild engine via ICAP

- **Allowed clients** : Public IP addresses allowed to use the proxy, this is handy if you are hosting the proxy somewhere online, not locally or in an internal network 

## Protected domains configuration

Modify `/etc/squid/squid.conf` , find the first line that starts with `acl protected dstdomain` , lines for new domains in the following format.

```
acl protected dstdomain example.com
```

For some advanced usages, refer to [SquidACL wiki page](https://wiki.squid-cache.org/SquidFaq/SquidAcl#ACL_elements) , some elements like `dstdom_regex` and `dst_sa` can be useful.

## Allowed clients configuration

Modify `/etc/squid/squid.conf` , find the first line that starts with `acl allowed_clients src` , lines for new domains in the following formats.

```
acl allowed_clients src 1.2.3.4
acl allowed_clients src 5.6.7.8/28
```

For some advanced usages, refer to [SquidACL wiki page](https://wiki.squid-cache.org/SquidFaq/SquidAcl#ACL_elements) , some elements like `src_as` and `browser` can be useful.
