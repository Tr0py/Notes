A large source tree could dramatically increase your clone time and eat up your
disk space.  Use `shallow clone` to avoid this.

```
git clone <git-repo> --depth=10
```

And you can deepen the git histroy by using `git pull`

```
git pull --depth=20
```

You can then update your repo and push your new commits normally, with a much
smaller local repo.

TODO: I don't know if you can push a shallow clone to a new repo.  If that
works, it would greatly save my cloud space (bitbucket has a limit of 2G for
free users).
