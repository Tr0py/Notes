
Use `ffmpeg` with H.265 encoding to compress video!  Higer CRF means **higer**
compress rate.

```bash
ffmpeg -i input.mp4 -vcodec libx265 -crf 28 output.mp4
```
