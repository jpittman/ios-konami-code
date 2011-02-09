
ios konami code
===

This little project allows you to implement the "Konami Code" inside of a view in your iOS app.  By including a couple of classes to your project and subclassing the provided view controller, you can provide cheats or easter eggs to your users.

Use
---

To use, do the following:

1. Add the classes to your project by doing one of the following:

    a. Open up the sample app project and drag the Konami Code group into your project tree.
    
    b. Add the following class files to your Project:

    * CheatCode.h/.m
    * KonamiCodeViewController.h/.m
    
2. Subclass the KonamiCodeViewController.

3. Implement the CheatCodeDelegate method "- (void) didEnterCodeSuccessfully" on the subclass.  See CheatCode.h for more details

And that's it.

When you subclass the view controller, you can enable the visibility of a UILabel that will print out the actions taken.  This helps in testing to make sure your actions are being tracked correctly.

License
---

This project's code is distributed under the terms of the MIT License.  See the license.txt file for complete text.

Contributions
---

Please feel free to fork, fix, enhance or add and send me a pull request with the result.  And if you decide to use this code in a published project, send me a message with a link.

Extra
---

For more info on the Konami Code, check out the wikipedia article: 

http://en.wikipedia.org/wiki/Konami_Code

Anamanaguchi provided the soundtrack to this little coding project.  Check'em out at:

http://www.anamanaguchi.com/