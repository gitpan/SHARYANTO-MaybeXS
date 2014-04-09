package SHARYANTO::MaybeXS;

use 5.010001;
use strict;
use warnings;

our $VERSION = '0.02'; # VERSION

our $USE_XS = 1;

require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(
                       clone
                       uniq
               );

sub clone {
    my $data = shift;
    goto FALLBACK unless $USE_XS;
    goto FALLBACK unless eval { require Data::Clone; 1 };

  STANDARD:
    return Data::Clone::clone($data);

  FALLBACK:
    require Clone::PP;
    return Clone::PP::clone($data);
}

sub uniq {
    goto FALLBACK unless $USE_XS;
    goto FALLBACK unless eval { require List::MoreUtils; 1 };

  STANDARD:
    return List::MoreUtils::uniq(@_);

  FALLBACK:
    my %h;
    my @res;
    for (@_) {
        push @res, $_ unless $h{$_}++;
    }
    return @res;
}

1;
#ABSTRACT: Do task using non-core XS module, but provide pure-Perl/core fallback

__END__

=pod

=encoding UTF-8

=head1 NAME

SHARYANTO::MaybeXS - Do task using non-core XS module, but provide pure-Perl/core fallback

=head1 VERSION

version 0.02

=head1 SYNOPSIS

 use SHARYANTO::MaybeXS qw(clone uniq);

 my $clone = clone({blah=>1});

=head1 DESCRIPTION

This module helps when you want to bootstrap your Perl application with a
portable, dependency-free Perl script. In a vanilla Perl installation (having
only core modules), you can use L<App::FatPacker> to include pure-Perl
dependencies to your script. This module provides fallback for some tasks that
usually need to be done using a non-core XS module, by providing alternatives
using pure-Perl or core XS module.

=for Pod::Coverage ^()$

=head1 FUNCTIONS

=head2 clone($data) => $cloned

Try to use L<Data::Clone>'s C<clone>, but fallback to L<Clone::PP>'s C<clone>.

=head2 uniq(@ary) => @uniq_ary

Try to use L<List::MoreUtils>'s C<uniq>, but fallback to using pure-Perl
implementation.

=head1 SEE ALSO

L<Clone::Any> can also uses multiple backends, but I avoid it because I don't
think L<Storable>'s C<dclone> should be used (no Regexp support out of the box +
must use deparse to handle coderefs).

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/SHARYANTO-MaybeXS>.

=head1 SOURCE

Source repository is at L<https://github.com/sharyanto/perl-SHARYANTO-MaybeXS>.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website L<https://rt.cpan.org/Public/Dist/Display.html?Name=SHARYANTO-MaybeXS>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
