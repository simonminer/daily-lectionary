# daily-lectionary
Tools for looking up and reading Scriptures for the ACNA Daily Lectionary

# API Call Examples

## Daily Lectionary Readings.
``
https://www.lectserve.com/date/yyyy-mm-dd
``

## Audio File Path

``
https://dbt.io/audio/path?key=<access_key>&dam_id=ENGESVN2DA&book_id=John&chapter_id=1&v=2
``

Fetches the relative path to the John 1 MP3 file.

## Verse Timecodes List

``
https://dbt.io/audio/versestart?key=<access_key>&dam_id=ENGESVN2DA&osis_code=John&chapter_number=1&v=2
``

Fetches timecode data for verses in John 1.

### MP3 Files with Timecodes

``
https://fcbhabdm.s3.amazonaws.com/mp3audiobibles2/ENGESVN2DA/B04___01_John________ENGESVN2DA.mp3#t=68.053
``

Plays John 1:14 and following verses in chapter 1.
