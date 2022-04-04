# TeamChallenge

## Task

Replicate the design on iOS.
Image shows a 3x3 grid with the top left having a 2x2 image
with the remaining 5 grid cells containing a 1x1 image.

The app starts with the "Settings" screen showing the images
and the bio text.  The Member is randomly chosed from the 19
entries in the team.json file.  5 additional images are made
as a call for member images, each is randomly chosen and is
compared to the existing member image and each previous image
so as to have no repeating images.

## Long Press

LongPress is implemented by adding 6 identical buttons which
overlay the imageViews and are activated as a toggle by the
long press gesture.  Once visible, selecting any "X" button
shifts the remaining images by manipulating the image view
origins, and marking "deleted" images as hidden.

## Screenshot and email

Code is implemented to perform the screenshot, and also to
post an email.  However, the simulators and all of my test
devices are not configured to use the Mail program, so the
code is tested only so far as to compose the email with an
image, but it is untested, and may or may not display what
is expected based on the mail service used by the recipient(s).


## Design

### Trial and Error

I looked for a way to use a collection view, but even using the
new compositional layout, it seems nearly impossible to have the
grid shift left when one cell was removed.

### Final Implementation Decision

Ultimately, I created a set of 6 imageViews, and wrote code to
dynamically resize and position them for the current device based
on the screen width.  This implementation ONLY works in Portrait
orientation.  No scrollView is used, so in landscape orientation
the views are cut off.

### Network fetch of Images

I could have used a synchronous fetch, but decided to use Apple's
URLCache as an image cache, grabbing each image asynchronously.
Sometimes the images appear blank, even when all six images show
as being loaded.  For the sake of brevity, restarting the App
usually gets all 6 images.

I tested prefetching all the images in viewDidLoad, and possibly
tried re-fetching them in both viewWillAppear and viewDidAppear
and the results were the same regardless of how many times I sent
a request for the images.  Most of the time, I see 6 images, but
sometims one or two images do not appear to load correctly.

### Team data is handled by the Team class

The JSON file is read and processed into an array of Member
structs created from each dictionary in the JSON data. 
Appropriate calls initialize the data, and obtain appropriate
member information..

## Conclusion

It works as expected.  It's not pixel perfect, and there are
some things which can be improved if more time is spent with
testing different options.

All in all, it was a little fun to do.


