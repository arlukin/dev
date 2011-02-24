import javax.microedition.lcdui.*;
import javax.microedition.midlet.MIDlet;
import javax.microedition.media.*;
import java.io.InputStream;

public class jeFace
	extends MIDlet
	implements CommandListener
{
	private Display display;

	private Form mainForm;



	private Player player;

	// Actions
	private static String CMD_EXIT    = "Exit";
	private static String CMD_WELCOME = "Welcome";
	private static String CMD_SLAPP   = "Slapp";
	private static String CMD_FEED    = "Feed";
	private static String CMD_SLEEP   = "SLEEP";

	// Images
	static String normalPhotoUrl;
	static String sleepyPhotoUrl;
	Image normalPhoto;
	Image sleepyPhoto;

	// Sounds
	static String welcomeSoundUrl;
	static String sleepSoundUrl;


	// Displayables
	//BluePadCanvas canvas;

	/**
	 * This is the text displayed in the ticker.
	 */
	private static final String TICKER_TEXT = "This is Johan Toan your new friend." +
									" You can do all kind of things with him, feed, slap, kiss him" +
									" and many many more things.";
	//

	public jeFace()
	{
		display = Display.getDisplay(this);

		// Rubrik
		mainForm = new Form("jeVirtualFace 2.0 Beta");

		// Ticker
		Ticker t = new Ticker(TICKER_TEXT);
		mainForm.setTicker(t);

		try
		{
			//
			if (display.numColors() > 2)
			{
				normalPhotoUrl = getAppProperty("IMG-WELCOME");
				sleepyPhotoUrl = getAppProperty("IMG-SLEEPY");

				InputStream is = getClass().getResourceAsStream(normalPhotoUrl);
				normalPhoto = Image.createImage(is);

				is = getClass().getResourceAsStream(sleepyPhotoUrl);
				sleepyPhoto = Image.createImage(is);

				mainForm.append(normalPhoto);
			}
		}
		catch (Exception ex)
		{
	    ex.printStackTrace();
	    if (player != null)
				player.close();
	    player = null;
		}

		// Create the right menu Canvas
		mainForm.addCommand(new Command(CMD_EXIT, Command.SCREEN, 1));
		//mainForm.addCommand(new Command(CMD_SLAPP, Command.SCREEN, 2));
		//mainForm.addCommand(new Command(CMD_FEED, Command.SCREEN, 3));
		mainForm.addCommand(new Command(CMD_WELCOME, Command.SCREEN, 4));
		mainForm.addCommand(new Command(CMD_SLEEP, Command.SCREEN, 5));
		mainForm.setCommandListener(this);

		// Sounds
		welcomeSoundUrl = getAppProperty("WAV-WELCOME");
		sleepSoundUrl   = getAppProperty("WAV-SLEEPY");
	}

  public void startApp()
  {
		display.setCurrent(mainForm);
  }

	//

  public void commandAction(Command c, Displayable s)
  {
		// EXIT
		if (c.getLabel().equals(CMD_EXIT))
		{
			destroyApp(false);
	  	notifyDestroyed();
		}

		// SLAPP
		if (c.getLabel().equals(CMD_WELCOME))
		{
			welcome();
			return;
		}

		// SLAPP
		if (c.getLabel().equals(CMD_SLAPP))
		{
			slapp();
			return;
		}

		// FEED
		if (c.getLabel().equals(CMD_FEED))
		{
			feed();
			return;
		}

		// SLEEP
		if (c.getLabel().equals(CMD_SLEEP))
		{
			sleep();
			return;
		}
  }

	//
  public void welcome()
  {
		mainForm.delete(0);
		mainForm.append(normalPhoto);

		playsound(welcomeSoundUrl, 1);
	}

	//

  public void slapp()
  {
		mainForm.delete(0);
		mainForm.append(sleepyPhoto);
	}

	//

	public void feed()
	{
		mainForm.delete(0);
		mainForm.append(normalPhoto);
	}

	//

  public void sleep()
  {
		mainForm.delete(0);
		mainForm.append(sleepyPhoto);

		playsound(sleepSoundUrl, 5);
	}

  //

  private void playsound(String url, int repeat)
  {
		try
		{
			if (player != null)
				player.stop();

			InputStream is = getClass().getResourceAsStream(url);
			player = Manager.createPlayer(is, "audio/x-wav");

			player.setLoopCount(repeat);
			player.start();

		}
		catch (Exception ex)
		{
	    ex.printStackTrace();
	    if (player != null)
				player.close();
	    player = null;
		}
	}


	//

  public void pauseApp () {}

	//

  public void destroyApp(boolean unconditional) {}
}

