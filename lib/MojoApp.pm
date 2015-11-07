package MojoApp;
use Mojo::Base 'Mojolicious';

use MojoApp::Model::Users;

sub startup {
	my $self = shift;

	$self->secrets(['Mojolicious rocks']);
	$self->helper(users => sub { state $users = MojoApp::Model::Users->new });

	my $r = $self->routes;

	$r->any('/' => sub {
		my $c = shift;

		my $user = $c->param('user') || '';
		my $pass = $c->param('pass') || '';
		return $c->render unless $c->users->check($user, $pass);

		$c->session(user => $user);
		$c->flash(message => 'Thanks for logging in.');
		$c->redirect_to('protected');
	} => 'index');

	my $logged_in = $r->under(sub {
		my $c = shift;
		return 1 if $c->session('user');
		$c->redirect_to('index');
		return undef;
	});
	$logged_in->get('/protected');

	$r->get('/logout' => sub {
		my $c = shift;
		$c->session(expires => 1);
		$c->redirect_to('index');
	});
}

1;