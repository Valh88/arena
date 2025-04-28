package view.ui.haxeui;

import haxe.Constraints.Function;
import haxe.ui.events.ValidatorEvent;
import haxe.ui.events.UIEvent;
import haxe.ui.events.ValidationEvent;
import haxe.ui.containers.VBox;
import haxe.ui.core.Screen;
import haxe.ui.events.MouseEvent;
import haxe.ui.containers.menus.Menu;
import haxe.ui.notifications.NotificationType;
import haxe.ui.notifications.NotificationManager;
import haxe.ui.events.UIEvent;
import haxe.ui.events.ValidatorEvent;

@:build(haxe.ui.macros.ComponentMacros.build("assets/haxeui/login_password_input.xml"))
class InputLoginPassword extends VBox
{
	public var onConnectCallback:Function;

	@:bind(form1, ValidatorEvent.INVALID_DATA)
	private function onFormInvalidData(event:ValidatorEvent)
	{
		if (form1.invalidFieldMessages.exists(username))
		{
			username.text = form1.invalidFieldMessages.get(username).join("\n");
			username.show();
		}
		if (form1.invalidFieldMessages.exists(password))
		{
			password.text = form1.invalidFieldMessages.get(password).join("\n");
			password.show();
		}
	}

	@:bind(form1, UIEvent.SUBMIT_START)
	private function onFormSubmitStart(event:UIEvent)
	{
		// username.hide();
		// password.hide();
		trace(username.text);
		trace(password.text);
		if (onConnectCallback != null)
		{
			onConnectCallback();
		}
	}

	@:bind(form1, UIEvent.SUBMIT)
	private function onFormSubmit(event:UIEvent)
	{
		NotificationManager.instance.addNotification(
			{
				title: "Form Submitted",
				body: "Login form submitted successfully!",
				type: NotificationType.Success
			});
	}
}
