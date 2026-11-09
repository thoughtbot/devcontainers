# Codespaces

[GitHub Codespaces][1] is convenient, but has a few things to be aware of, and
some changes that might need changing to work well.

## Personalisation

It's worth [exploring the supported customisation options][2] provided for
tools you might want, or VS Code settings.

## Disabling CSRF for Rails (and other similar tools)

The [Origin header is incorrectly rewritten][3], which leads to certain
requests failing. This seems to be something Codespaces isn't going to fix, so
it needs to be worked around. In Rails, for example:

```ruby
# config/environments/development.rb
if ENV["GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN"] == "app.github.dev"
    warn "WARNING: (development) Disabling CSRF protection Origin header check!"
    config.action_controller.forgery_protection_origin_check = false
end
```

[GitHub Community Post][4]

## 401 Unauthorized responses over shared ports

Sometimes, an opened port still returns a `401 Unauthorized` response even when
everything else is configured correctly.

You might be able to resolve this by making the shared port "public" and then
switching back to "private". This then seems to work as expected for the rest
of the session.

[GitHub Community Post][5].

## Other problems

* Setup problems can usually be understood by [browsing the creation log][6],
* VS Code for the Web generally works terribly in Firefox, but you might be
  lucky,
  - Pages won't render because of [_Enhanced Privacy Mode_ in the "Simple
    Browser"][7],
  - Occasionally, you'll find you can't click in any of the text areas
* [GitHub has documented some further troubleshooting steps][8],
* But be aware that you'll find various bugs which have existed for years and
  likely won't ever be fixed

[1]: https://docs.github.com/en/codespaces
[2]: https://docs.github.com/en/codespaces/setting-your-user-preferences/personalizing-github-codespaces-for-your-account
[3]: https://discuss.rubyonrails.org/t/project-doesnt-run-in-github-codespaces/84046/9
[4]: https://github.com/orgs/community/discussions/156532
[5]: https://github.com/orgs/community/discussions/69610
[6]: https://docs.github.com/en/codespaces/troubleshooting/github-codespaces-logs#creation-logs
[7]: https://github.com/orgs/community/discussions/149916
[8]: https://docs.github.com/en/codespaces/troubleshooting/troubleshooting-github-codespaces-clients
