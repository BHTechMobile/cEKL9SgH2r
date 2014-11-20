//
//  EventListViewController.m
//  EventApp
//
//  Created by Tommy on 11/17/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import "EventListViewController.h"
#import "EventDetailViewController.h"
#import "EAEventsDetails.h"
#import "AppDelegate.h"
#import "EventListTableViewCell.h"

@interface EventListViewController ()

@end

@implementation EventListViewController{
    NSDictionary *dictEvents;
    NSArray *arrayEvents;
    EventDetailViewController *eventDetailViewController;
    EAEventsDetails *eaEventsDetails;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData ];
    arrayEvents = [[NSArray alloc]init];
    NSData* data = [NSData dataWithContentsOfURL:ALL_EVENTS_LIST_URL_JSON];
    [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)fetchedData:(NSData *)responseData {
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    arrayEvents = [[[[[json objectForKey:@"cids"]objectForKey:@"calendars%40startupdigest.com/private/embed"] objectForKey:@"gdata"] objectForKey:@"feed"] objectForKey:@"entry"];
    
    NSLog(@"entry: %@", arrayEvents);
}

- (void)insertData {
    for (int i = 0; i < arrayEvents.count; i++) {
        eaEventsDetails = (EAEventsDetails *)[NSEntityDescription insertNewObjectForEntityForName:@"EAEventsDetails" inManagedObjectContext:EAManagedObjectContext];
        eaEventsDetails.eventId = [[[arrayEvents objectAtIndex:i] valueForKey:@"id"]valueForKey:@"$t"];
        eaEventsDetails.contentDescription = [[[arrayEvents objectAtIndex:i] valueForKey:@"content"]valueForKey:@"$t"];
        eaEventsDetails.contentType = [[[arrayEvents objectAtIndex:i] valueForKey:@"content"]objectForKey:@"type"];
        eaEventsDetails.titleName = [[[arrayEvents objectAtIndex:i] valueForKey:@"title"]valueForKey:@"$t"];
        eaEventsDetails.titleType = [[[arrayEvents objectAtIndex:i] valueForKey:@"title"]valueForKey:@"type"];
        eaEventsDetails.linkRel = [[[[arrayEvents objectAtIndex:i] valueForKey:@"link"]firstObject]valueForKey:@"rel"];
        eaEventsDetails.linkType = [[[[arrayEvents objectAtIndex:i] valueForKey:@"link"]firstObject]valueForKey:@"type"];
        eaEventsDetails.linkHref = [[[[arrayEvents objectAtIndex:i] valueForKey:@"link"]firstObject]valueForKey:@"href"];
        eaEventsDetails.eventWhere = [[[[arrayEvents objectAtIndex:i] valueForKey:@"gd$where"]firstObject]valueForKey:@"valueString"];
        eaEventsDetails.eventEndTime = [[[[arrayEvents objectAtIndex:i] valueForKey:@"gd$when"]firstObject]valueForKey:@"endTime"];
        eaEventsDetails.eventStartTime = [[[[arrayEvents objectAtIndex:i] valueForKey:@"gd$when"]firstObject]valueForKey:@"startTime"];
        
        NSLog(@"Done %@",eaEventsDetails);
        
        NSError *error;
        if (![EAManagedObjectContext save:&error]) {
            NSLog(@"Problem saving: %@", [error localizedDescription]);
        }
    }
}

- (void)getData{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EAEventsDetails" inManagedObjectContext:EAManagedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setFetchBatchSize:20];
    [request setEntity:entity];
    
    NSError *error;
    
    NSArray *results = [[EAManagedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    [self setGetListEvents:results];
    [self.listEventsTable reloadData];
}

#pragma mark - Table View Delegate - Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return arrayEvents.count;
    return _getListEvents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = TABLE_IDENTIFIER_ID_ID;
    EventListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[EventListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
//    eaEventsDetails = [_getListEvents objectAtIndex:indexPath.row];
//    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
//    [_formatter setDateFormat:@"dd/MM/yy HH:mm"];
//    NSString *startTimes = [_formatter stringFromDate:eaEventsDetails.eventStartTime];
//    NSString *endTimes = [_formatter stringFromDate:eaEventsDetails.eventEndTime];
    
      cell.titleEvents.text = [[[arrayEvents objectAtIndex:indexPath.row] valueForKey:@"title"]valueForKey:@"$t"];
//    cell.titleEvents.text = eaEventsDetails.titleName;
//    cell.timeTitleEvents.text = [NSString stringWithFormat:@"From %@ to %@",startTimes,endTimes];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"viewEventDetails" sender:nil];
    //    eventDetailViewController.navigationItem.title = [[[arrayEvents objectAtIndex:indexPath.row] valueForKey:@"title"]valueForKey:@"$t"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"viewEventDetails"]) {
        eventDetailViewController = [segue destinationViewController];
    }
}


- (IBAction)refreshListEventsAction:(id)sender {
    [self insertData];
}
@end
