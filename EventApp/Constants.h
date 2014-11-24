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

#define EAManagedObjectContext [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]
#define EAManagedObjectModel   [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectModel]

#define CIDS_MAIN_KEY @"cids"
#define CALENDAR_EMBED_MAIN_KEY @"calendars%40startupdigest.com/private/embed"
#define GDATA_MAIN_KEY @"gdata"
#define FEED_MAIN_KEY @"feed"
#define TITLE_MAIN_KEY @"title"
#define DETAILS_KEY @"$t"
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
#define FORMAT_DATE @"yyyy-MM-dd'T'HH:mm:ss.SSS-HH:mm"

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

#define ALL_EVENTS_LIST_URL_JSON [NSURL URLWithString:@"https://dl.dropboxusercontent.com/s/jv6b38u1jri5c99/data.json"]

#define EAEVENTLIST_KEY_ID @"id"

#define HEIGHT_CELL_LIST_EVENT 55
#define WIDTH_CONTENT_CELL_DETAIL 240

/*CoreDataHelper*/
#define EAKey_Id           @"id"
#define EAKey_Title        @"title"
#define EAKey_Front        @"front"

#define CONDITION_EQUAL    @"="
#define CONDITION_CONTAINS @"CONTAINS"

#define LogError(error) NSLog(@"%s - Error %@", __PRETTY_FUNCTION__, error)

#endif
