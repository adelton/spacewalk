package NOCpulse::Notif::BlackholeRedirect;             

@ISA = qw(NOCpulse::Notif::Redirect);  
use strict;
use NOCpulse::Notif::Redirect;
use NOCpulse::Log::Logger;

my $Log = NOCpulse::Log::Logger->new('redirects');


##############
sub redirect {
##############
  my ($self,$alert)=@_;

  return unless $self->matches($alert);
  @{$alert->originalDestinations()} = (); 
}

1;

__END__

=head1 NAME

NOCpulse::Notif::BlackholeRedirect - A type of advanced notification that discards all original recipients of the alert.

=head1 SYNOPSIS

# Create a new, empty redirect
$redirect=NOCpulse::Notif::BlackholeRedirect->new(
  'start_date' => $timestamp1
  'expiration' => $timestamp2,
  'description' => 'blah',
  'reason'      => 'some long-winded explanation',
  'customer_id' => $customer_id,
  'contact_id'  => $contact_id );

# Add a redirect criterion
$redirect->add_criterion($redirect_criterion);

=head1 DESCRIPTION

The C<BlackholeRedirect> object is a type of redirect that clears out all the members of an alerts original destinations.

=head1 CLASS METHODS

=over 4

=item new ( [%args] )

Create a new object with the supplied arguments, if any.

=back

=head1 METHODS

=over 4

=item redirect ( $alert )

Checks to see if the redirect applies to the given alert and if so, clears out the original destinations.

=back

=head1 BUGS

No known bugs.

=head1 AUTHOR

Karen Jacqmin-Adams <kja@redhat.com>

Last update: $Date: 2004-11-18 17:13:13 $

=head1 SEE ALSO

B<NOCpulse::Notif::Redirect>
B<NOCpulse::Notif::Alert>
B<notifserver.pl>

=cut
