use Glib qw/TRUE FALSE/;
use Gtk2 '-init';

$window = Gtk2::Window->new('toplevel');
$window->signal_connect(delete_event => sub { Gtk2->main_quit; return FALSE; });
$window->set_title("radio buttons");
$window->set_border_width(0);

$box1 = Gtk2::VBox->new(FALSE, 0);
$window->add($box1);
$box1->show;

$box2 = Gtk2::VBox->new(FALSE, 10);
$box2->set_border_width(10);
$box1->pack_start($box2, TRUE, TRUE, 0);
$box2->show;

$button = Gtk2::RadioButton->new(undef, "button 1");
$box2->pack_start($button, TRUE, TRUE, 0);
$button->show;

@group = $button->get_group;
$button = Gtk2::RadioButton->new_with_label(@group, "button 2");
$button->set_active(TRUE);
$box2->pack_start($button, TRUE, TRUE, 0);
$button->show;

$button = Gtk2::RadioButton->new_with_label_from_widget($button, "button 3");
$box2->pack_start($button, TRUE, TRUE, 0);
$button->show;

$separator = Gtk2::HSeparator->new;
$box1->pack_start($separator, FALSE, TRUE, 0);
$separator->show;

$box2 = Gtk2::VBox->new(FALSE, 10);
$box2->set_border_width(10);
$box1->pack_start($box2, FALSE, TRUE, 0);
$box2->show;

$button = Gtk2::Button->new("close");
$button->signal_connect(clicked => sub { Gtk2->main_quit; });
$box2->pack_start($button, TRUE, TRUE, 0);
$button->can_default(TRUE);
$button->grab_default;
$button->show;
$window->show;

Gtk2->main;

0;
