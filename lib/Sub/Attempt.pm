package Sub::Attempt;

use 5.006;

use Exporter qw{import};

use strict;

=head1 NAME

Sub::Attempt - Attempt to execute a block N times before forwarding an exception

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

our @EXPORT_OK = qw{
	attempt
};
our %EXPORT_TAGS = (all => [@EXPORT_OK]);

=head1 SYNOPSIS

This module exports a single function called attempt, which tries to execute
a subroutine N times before throwing the exception.  Optionally, an error
handler may be provided to take any specialized action with the error after
each attempt.  The primary inspiration was to add reliability to code when
interfacing with inherently unreliable processes.  See the example below.

    use Sub::Attempt qw{attempt};

    use LWP::UserAgent;
    use HTTP::Request;
    my $user_agent = LWP::UserAgent->new(); 
    attempt 3,
        sub {
            my $request = HTTP::Request->new(GET => "http://some-url.com");
            my $response = $user_agent->request($request);
            die $response->status_line unless $response->is_success;
        },
        sub {
            my $err = shift; 
            warn "Failed to make request $err";
            sleep 1;
        };

=head1 EXPORT

Exports:
	attempt

=head1 SUBROUTINES/METHODS

=head2 attempt($&;&)

Given a count and a subroutine, attempt to execute the subroutine
until it succeeds, throwing the failure once the subroutine has
been executed count times.  An optional error handler may be
provided to process the error passed to it after each failure.
Attempt preserves context.  If no count is provided, then attempt
acts as a NOOP.

=cut

sub attempt($&;&) {
	my ($count, $function, $error_handler) = @_;

	return unless $count > 0;

	my $wantarray = wantarray;
	my $error;

	while ($count-- > 0) {
		my $result;
		eval {
			if ($wantarray) { @$result = $function->() }
			else            {  $result = $function->() }
		;1 } || do {
			$error = $@;
			$error_handler->($error) if $error_handler;
			next;
		};
		return $wantarray ? @$result : $result;
	}
	die $error;
}

=head1 AUTHOR

Aaron Cohen, C<< <aarondcohen at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-sub-attempt at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Sub-Attempt>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Sub::Attempt


You can also look for information at:

=over 4

=item * Official GitHub Repository

L<http://github.com/aarondcohen/Sub-Attempt>

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Sub-Attempt>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Sub-Attempt>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Sub-Attempt>

=item * Search CPAN

L<http://search.cpan.org/dist/Sub-Attempt/>

=back


=head1 SEE ALSO

L<Sub::Retry>

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Aaron Cohen.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Sub::Attempt
