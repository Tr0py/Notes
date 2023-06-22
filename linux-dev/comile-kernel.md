
# Kernel Signature Missing

If you use Ubuntu's config to compile Linux, you'll probably fail due to lack of
keys, with following error message:

```
make[1]: *** No rule to make target 'debian/canonical-certs.pem', needed by 'certs/x509_certificate_list'.  Stop.
```

Just disable keyring.

```
scripts/config --disable SYSTEM_TRUSTED_KEYS
scripts/config --disable SYSTEM_REVOCATION_KEYS
```

Then make again, and you'll be asked to provide additional keyring.  Ignore that
and leave the key blank by **tapping Enter**.

```
Provide system-wide ring of trusted keys (SYSTEM_TRUSTED_KEYRING) [Y/?] y
  Additional X.509 keys for default system keyring (SYSTEM_TRUSTED_KEYS) [] (NEW)
```

Then the kernel will compile.
