#!/usr/bin/env perl
use Mojolicious::Lite;

use lib 'lib';
use MojoApp::Model::Users;

# Make signed cookies secure
app->secrets(['Mojolicious rocks']);

helper users => sub { state $users = MojoApp::Model::Users->new };

# Main login action
any '/' => sub {
	my $c = shift;

	# Query or POST parameters
	my $user = $c->param('user') || '';
	my $pass = $c->param('pass') || '';

	# Check password and render "index.html.ep" if necessary
	return $c->render unless $c->users->check($user, $pass);

	# Store username in session
	$c->session(user => $user);

	# Store a friendly message for the next page in flash
	$c->flash(message => 'Thanks for logging in.');

	# Redirect to protected page with a 302 response
	$c->redirect_to('protected');
} => 'index';

# Make sure user is logged in for actions in this group
group {
	under sub {
		my $c = shift;

		# Redirect to main page with a 302 response if user is not logged in
		return 1 if $c->session('user');
		$c->redirect_to('index');
		return undef;
	};

	# A protected page auto rendering "protected.html.ep"
	get '/protected';
};

# Logout action
get '/logout' => sub {
	my $c = shift;

	# Expire and in turn clear session automatically
	$c->session(expires => 1);

	# Redirect to main page with a 302 response
	$c->redirect_to('index');
};

app->start;