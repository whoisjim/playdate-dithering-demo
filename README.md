# Playdate Dithering Demo

I was a bit unhappy with the examples in [Designing for Playdate section 1.7 Dither flashing](https://sdk.play.date/1.12.3/Designing%20for%20Playdate.html#_dither_flashing) so I spent some time experimenting and figured Id share.

Here is the ball in grayscale that I'm using without any processing or filters.

![ball_origional|128x128](/assets/ball_origional.png)

![playdate-20230129-131808|400x240](/assets/playdate-20230129-131808.gif)

Listed from top to bottom here is what your seeing.

1. This ball is a 5 color posterized image, that the playdate is then dithering each frame so we don't get any flickering as the dithering pattern stays in the same spot in the screen, only the stencil moves. the downside of this is it takes much longer to draw. This is what the image looks like without the real time dithered.

![ball_5posterize|128x128](/assets/ball_5posterize.png)

2. This is the same as the previous but with 5 color dithering instead of just the posterization.

![ball_5dither|128x128](/assets/ball_5dither.png)

3. This ball only uses preprocessed dithering.

4. This ball only uses preprocessed dithering but its pixels are twice as big.

## Files

`main.lua` is the demo source code 

`asesprite_export_by_color.lua` is an exporter for asesprite that generates the masks used in 1 and 2

`assets` contains all the image files