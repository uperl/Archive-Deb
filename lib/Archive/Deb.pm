use warnings;
use 5.022;
use experimental qw( postderef signatures );

package Archive::Deb {

  # ABSTRACT: Module for reading Debian .deb files

  use Archive::Libarchive::Peek;
  use Archive::Libarchive::Extract;
  use Path::Tiny;
  use Carp qw( croak );

  sub new ($class, $path)
  {
    croak "File $path does not appear to be a Debian package" unless $path =~ /\.deb$/;

    my %self;

    Archive::Libarchive::Peek->new( filename => $path )->iterate( sub ($filename, $content, $e) {
      if($filename eq 'debian-binary')
      {
        chomp $content;
        unless($content eq '2.0')
        {
          warn "version \"$content\" does not match expected \"2.0\"";
        }
        $self{version} = $content;
      }
      elsif($filename =~ /^control\.tar/)
      {
        $self{control} = $content;
      }
      elsif($filename =~ /^data\.tar/)
      {
        my $path = Path::Tiny->tempfile( "debdataXXXXXX" );
        $path->spew_raw($content);
        $self{data} = $path;
      }
      else
      {
        warn "unrecongized file in Debian archive: $filename";
      }
    });

    my @missing = grep { ! defined $self{$_} } qw( version control data );
    croak "File $path is missing these sections: @missing" if @missing;

    bless \%self, $class;
  }

  sub version ($self) { $self->{version} }

  sub data ($self)
  {
    return Archive::Libarchive::Peek->new( filename => $self->{data}->stringify )
  }

  sub data_extractor ($self)
  {
    return Archive::Libarchive::Extract->new( filename => $self->{data}->stringify );
  }

}

1;

=head1 SYNOPSIS

 use Archive::Deb;

 my $deb = Archive::Deb->new( "foo.deb" );
 say $_ for $deb->data->files;

=head1 DESCRIPTION

This is a simple interface for peeking into a Debian C<.deb> package/archive.

=head1 CONSTRUCTOR

=head2 new

 my $deb = Archive::Deb->new( $path );

Given the path to a Debian C<.deb> package/archive this will create a new
instance of L<Archive::Deb>.  Will warn if something unexpected is found
and will throw an exception if C<$path> is invalid or missing.

=head1 METHODS

=head2 version

 my $version = $deb->version;

Returns the Debian binary version.  This is C<2.0> for recent versions of
Debian.

=head2 data

 my $peek = $deb->data;

Returns an instance of L<Archive::Libarchive::Peek> for the data section of
the Debian archive.  This can be used to list the files in the archive,
or iterate over them.

=head2 data_extractor

 my $extract = $deb->data_extractor;

Returns an instance of L<Archive::Libarchive::Extract> for the data section
of the Debian archive.  This can be used to extract the files from the
archive.

=head1 SEE ALSO

=over 4

=item L<Archive::Libarchive>

=item L<Archive::Libarchive::Peek>

=item L<Archive::Libarchive::Extract>

=back

=cut
