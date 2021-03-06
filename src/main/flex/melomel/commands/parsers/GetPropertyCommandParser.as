/*
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * @author Ben Johnson
 */
package melomel.commands.parsers
{
import melomel.core.ObjectProxy;
import melomel.core.ObjectProxyManager;
import melomel.commands.GetPropertyCommand;
import melomel.commands.ICommand;

import flash.events.EventDispatcher;
import melomel.errors.MelomelError;

/**
 *	This class parses XML messages to build GetProperty commands. The parser
 *	handles the object proxy translation.
 *
 *	<p>The GET command has the following format:</p>
 *	
 *	<pre>
 *	&lt;get object="<i>proxy_id</i>" property="" throwable="true|false"/&gt;
 *	</pre>
 *	
 *	@see melomel.commands.GetPropertyCommand
 */
public class GetPropertyCommandParser extends ObjectProxyCommandParser
								   implements ICommandParser
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *	Constructor.
	 */
	public function GetPropertyCommandParser(manager:ObjectProxyManager)
	{
		super(manager);
	}
	

	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *	@copy ICommandParser#parse
	 */
	public function parse(message:XML):ICommand
	{
		// Verify message action
		if(!message) {
			throw new MelomelError("Message is required for parsing");
		}

		// Extract data from message
		var action:String     = message.localName();
		var proxyId:Number    = parseInt(message.@object);
		var object:Object     = manager.getItemById(proxyId);
		var property:String   = message.@property;
		var throwable:Boolean = (message.@throwable != "false");
		
		// Verify message action
		if(action != "get") {
			throw new MelomelError("Cannot parse action: '" + action + "'");
		}
		// Verify proxy id
		else if(isNaN(proxyId)) {
			throw new MelomelError("Missing 'object' reference in message");
		}
		// Verify proxy exists
		else if(!object) {
			throw new MelomelError("Object #" + proxyId + " does not exist");
		}
		// Verify property exists
		else if(property == null || property.length == 0) {
			throw new MelomelError("Property is required in message");
		}
		
		// Return command
		return new GetPropertyCommand(object, property, throwable);
	}
}
}