package Text::Anagram;

use 5.006;
use base 'Exporter';
use strict;
use warnings;
our @EXPORT_OK = qw< anagram >;
our $VERSION   = '0.4';

# ABSTRACT: do something with every anagram of a text

=head1 NAME

Text::Anagram - call user function with all anagrams of supplied text

=head1 SYNOPSIS

    use Text::Anagram qw< anagram >;

    anagram { say } "bob";

=head1 DESCRIPTION

Text::Anagram provides a function C<anagram> which generates all
anagrams of a text string, and invokes a user-supplied function
with each permutation.

This release is usable but far from a definitive API. Don't use in production.

=head1 FUTURE

Add a callback to stop a branch of solution

    use Text::Anagram qw< anagram >;

    anagram "bob"
    , stop    => sub { length > 2 && /^ana/ }
    , finally => sub { say }

also 

    * localize stuff to run anagrams in anagrams
    * compare anything (not only char) ? 

=head1 SEE ALSO

L<Word::Anagram>, L<Lingua::Anagrams>.

=head1 Fork me! 

L<https://github.com/eiro/p5-text-anagram>

=cut 

my $leaf_callback;

sub _anagram;
sub _anagram {
    my ( $from, $to) = @_;
    length $from or return map {$leaf_callback->()} $to;
    my %seen;
    $from =~ s{.}{ $seen{$&}++ or _anagram "$'$`","$&$to" }ge;
}

sub anagram (&$) {
    $leaf_callback = shift;
    my $seed = shift;
    _anagram $seed,'';
}

1;

=head1 AUTHOR

Marc Chantreux E<lt>marcc@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Marc Chantreux E<lt>marcc@cpan.orgE<gt>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

