# Archive::Deb ![static](https://github.com/uperl/Archive-Deb/workflows/static/badge.svg) ![linux](https://github.com/uperl/Archive-Deb/workflows/linux/badge.svg)

Module for reading Debian .deb files

# SYNOPSIS

```perl
use Archive::Deb;

my $deb = Archive::Deb->new( "foo.deb" );
say $_ for $deb->data->files;
```

# DESCRIPTION

This is a simple interface for peeking into a Debian `.deb` package/archive.

# CONSTRUCTOR

## new

```perl
my $deb = Archive::Deb->new( $path );
```

Given the path to a Debian `.deb` package/archive this will create a new
instance of [Archive::Deb](https://metacpan.org/pod/Archive::Deb).  Will warn if something unexpected is found
and will throw an exception if `$path` is invalid or missing.

# METHODS

## version

```perl
my $version = $deb->version;
```

Returns the Debian binary version.  This is `2.0` for recent versions of
Debian.

## data

```perl
my $peek = $deb->data;
```

Returns an instance of [Archive::Libarchive::Peek](https://metacpan.org/pod/Archive::Libarchive::Peek) for the data section of
the Debian archive.  This can be used to list the files in the archive,
or iterate over them.

## data\_extractor

```perl
my $extract = $deb->data_extractor;
```

Returns an instance of [Archive::Libarchive::Extract](https://metacpan.org/pod/Archive::Libarchive::Extract) for the data section
of the Debian archive.  This can be used to extract the files from the
archive.

# SEE ALSO

- [Archive::Libarchive](https://metacpan.org/pod/Archive::Libarchive)
- [Archive::Libarchive::Peek](https://metacpan.org/pod/Archive::Libarchive::Peek)
- [Archive::Libarchive::Extract](https://metacpan.org/pod/Archive::Libarchive::Extract)

# AUTHOR

Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2022 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
