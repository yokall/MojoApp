package MojoApp::Model::Users;

use strict;
use warnings;

my $USERS = {
	joel      => 'las3rs',
	marcus    => 'lulz',
	sebastian => 'secr3t'
};

sub new { bless {}, shift }

sub check {
	my ($self, $user, $pass) = @_;

	# Success
	return 1 if $USERS->{$user} && $USERS->{$user} eq $pass;

	# Fail
	return undef;
}

1;