# librsvg-overlay

This Gentoo overlay provides a librsvg fork with no rust dependencies.

(See https://github.com/oaken-source/librsvg-og for development)

**DISCLAIMER**: the development version/fork is stuck at 2.40.21,
and the new ebuild at version 2.52.5 is merely to trick portage,
in order to follow dependency requirements. Don't worry,
your apps will still work.

Proof: evince reading a PDF running librsvg from this repository:

![evince](https://raw.githubusercontent.com/saloniamatteo/librsvg-overlay/evince.png)

---

## Adding, Enabling Overlay and installing

If you don't have `app-portage/layman` already installed, read this [Gentoo wiki](https://wiki.gentoo.org/wiki/Layman).

Once you're done, run the following command to add this repository:

```
layman -o https://raw.githubusercontent.com/saloniamatteo/librsvg-overlay/master/repositories.xml -f -a librsvg-overlay
```

You will receive a warning saying this repository is unofficial.
Proceed, then run the following command, to sync the newly added repository, called librsvg-overlay:

```
layman -s librsvg-overlay
```

Now, you can run `emerge -s gnome-base/librsvg::librsvg-overlay` to install librsvg from this overlay.
