//
//  Constants.h
//  EventApp
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#ifndef EventApp_Constants_h
#define EventApp_Constants_h

#define SEGUE_INDENTIFIER @"viewEventDetails"
#define SEGUE_INDENTIFIER_MAP_VIEW @"pushMapWebView"
#define FONT_HELVETICA_BOLD @"Helvetica-Bold"
#define FONT_SIZE_HELVETICA_BOLD 14
#define MAIN_COLOR [UIColor colorWithRed:0.9608f green:0.2824f blue:0.1922f alpha:1]

#define EAManagedObjectContext [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]
#define EAManagedObjectModel   [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectModel]

#define EA_KEY_ID @"eventId"
#define EA_KEY_CONTENT_DESCRIPTION @"contentDescription"
#define EA_KEY_CONTENT_TYPE @"contentType"
#define EA_KEY_TITLE_NAME @"titleName"
#define EA_KEY_TITLE_TYPE @"titleType"
#define EA_KEY_LINK_REL @"linkRel"
#define EA_KEY_LINK_TYPE @"linkType"
#define EA_KEY_LINK_HREF @"linkHref"
#define EA_KEY_EVENT_WHERE @"eventWhere"
#define EA_KEY_EVENT_CREATED_BY @"eventCreatedBy"
#define EA_KEY_EVENT_CALENDAR_NAME @"eventCalendarName"
#define EA_KEY_EVENT_END_TIME @"eventEndTime"
#define EA_KEY_EVENT_START_TIME @"eventStartTime"

#define CIDS_MAIN_KEY @"cids"
#define CALENDAR_EMBED_MAIN_KEY @"calendars%40startupdigest.com/private/embed"
#define GDATA_MAIN_KEY @"gdata"
#define FEED_MAIN_KEY @"feed"
#define TITLE_MAIN_KEY @"title"
#define DETAILS_KEY @"$t"
#define SUMMARY_KEY @"summary"
#define AUTHOR_KEY @"author"
#define NAME_KEY @"name"
#define ENTRY_KEY @"entry"
#define EAEVENTS_DETAILS_KEY @"EAEventsDetails"
#define ID_MAIN_KEY @"id"
#define CONTENT_MAIN_KEY @"content"
#define TYPE_MAIN_KEY @"type"
#define LINK_MAIN_KEY @"link"
#define LINK_REL_MAIN_KEY @"rel"
#define LINK_HREF_MAIN_KEY @"href"
#define WHERE_MAIN_KEY @"gd$where"
#define VALUE_STRING_MAIN_KEY @"valueString"
#define WHEN_MAIN_KEY @"gd$when"
#define END_TIME_MAIN_KEY @"endTime"
#define START_TIME_MAIN_KEY @"startTime"
#define FORMAT_DATE_NO_MINUTE @"EEE MMM d, yyyy ha"
#define FORMAT_DATE @"EEE MMM d, yyyy h:ma"
#define FORMAT_DATE_ALL_DAY @"EEE MMM d, yyyy"
#define UNKNOWN_LOCATION @"Unknown Location"
#define FORMAT_SHORT_DATE @"yyyy-MM-dd"
#define FROM_TO @"From: %@ \n     to: %@"
#define JSON_NAME_CALENDAR [[[[[[json objectForKey:CIDS_MAIN_KEY]objectForKey:CALENDAR_EMBED_MAIN_KEY] objectForKey:GDATA_MAIN_KEY] objectForKey:FEED_MAIN_KEY]valueForKey:TITLE_MAIN_KEY]valueForKey:DETAILS_KEY]
#define JSON_CREATE_BY [[[[[[[[json objectForKey:CIDS_MAIN_KEY]objectForKey:CALENDAR_EMBED_MAIN_KEY] objectForKey:GDATA_MAIN_KEY] objectForKey:FEED_MAIN_KEY]valueForKey:AUTHOR_KEY]firstObject]valueForKey:NAME_KEY]valueForKey:DETAILS_KEY]
#define JSON_EVENTS_ARRAY [[[[[json objectForKey:CIDS_MAIN_KEY]objectForKey:CALENDAR_EMBED_MAIN_KEY] objectForKey:GDATA_MAIN_KEY] objectForKey:FEED_MAIN_KEY]valueForKey:ENTRY_KEY]

#define TABLE_IDENTIFIER_ID_ID @"TABLE_IDENTIFIER_ID"
#define EventDetailTableViewCell_ID @"EventDetailTableViewCell"
#define EventDetailMapTableViewCell_ID @"EventDetailMapTableViewCell"
#define EventDescriptionTableViewCell_ID @"EventDescriptionTableViewCell"

#define TITLE_TIME @"Time"
#define TITLE_LOCATION @"Location"
#define TITLE_CALENDAR @"Calendar"
#define TITLE_CREATED_BY @"Created by"
#define TITLE_DESCRIPTION @"Description"

#define EAEVENTLIST_KEY_ID @"eventId"

#define INDEX_PATH_ROW 0
#define INDEX_PATH_ROW_ 1
#define INDEX_PATH_ROW__ 2

#define AlertLinkMap 22
#define AlertLinkWeb 23
#define AlertLinkMail 24

#define LENGTH_SHORT_DATE_TIME 15

#define HEIGHT_CELL_LIST_EVENT 55
#define HEIGHT_CELL_DETAIL_EVENT 30
#define SPACE_HEIGHT_CELL_DETAIL_EVENT 5
#define SPACE_HEIGHT_CELL_DETAIL_EVENT_ 20
#define WIDTH_CONTENT_CELL_DETAIL 240
#define WIDTH_TITLE_CELL_DETAIL 290

#define NO_KEY @"No"
#define YES_KEY @"Yes"
#define QS_MAP_TITLE @"Location Message!"
#define QS_MAP @"Are you see location in maps? "
#define QS_WEB_TITLE @"Link Message!"
#define QS_WEB @"Are you go to the link? "

/*CoreDataHelper*/
#define EAKey_Id           @"id"
#define EAKey_Title        @"title"
#define EAKey_Front        @"front"

#define CONDITION_EQUAL    @"="
#define CONDITION_CONTAINS @"CONTAINS"

#define LogError(error) NSLog(@"%s - Error %@", __PRETTY_FUNCTION__, error)

#endif
