package melomel.commands
{
import org.flexunit.Assert;
import org.flexunit.async.Async;

import flash.display.Stage;

public class GetClassCommandTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------

	private var command:GetClassCommand;
	
	[Before]
	public function setUp():void
	{
		command = new GetClassCommand();
	}

	[After]
	public function tearDown():void
	{
		command = null;
	}


	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------
	
	//-----------------------------
	//  Execute
	//-----------------------------

	[Test]
	public function execute():void
	{
		command.name = "flash.display.Stage";
		Assert.assertEquals(Stage, command.execute());
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function executeWithoutName():void
	{
		command.name = null;
		command.execute();
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function executeWithInvalidClass():void
	{
		command.name = "does.not.Exist";
		command.execute();
	}
}
}