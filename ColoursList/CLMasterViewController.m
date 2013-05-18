//
//  CLMasterViewController.m
//  ColoursList
//
//  Created by Tatsuya Tobioka on 13/05/14.
//  Copyright (c) 2013年 Tatsuya Tobioka. All rights reserved.
//

#import "CLMasterViewController.h"

#import "CLDetailViewController.h"

#import <objc/runtime.h>

#import "UIColor+Colours.h"

@interface CLMasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation CLMasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
        
        _objects = @[].mutableCopy;
        
        unsigned count;
        Method *methods;
        Class targetClass = [UIColor class];
        
        // Instance Methods
        /*
        methods = class_copyMethodList(targetClass, &count);
        for (int i = 0; i < count; i++) {
            [_objects addObject:@[NSStringFromSelector(method_getName(methods[i]))]];
        }
         */
        
        // Class Methods
        methods = class_copyMethodList(object_getClass(targetClass), &count);
        for (int i = 0; i < count; i++) {
            // Select "Color$"
            NSString *name = NSStringFromSelector(method_getName(methods[i]));
            NSRange range = [name rangeOfString:@"Color$" options:NSRegularExpressionSearch];
            if (range.location != NSNotFound) {
                [_objects addObject:name];
            }
        }        
    
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }


    NSString *name = _objects[indexPath.row];
    cell.textLabel.text = name;
    cell.textLabel.backgroundColor = [UIColor clearColor];

    SEL selector = NSSelectorFromString(name);
    UIColor *color = nil;
    if ([UIColor respondsToSelector:selector]) {
        color = [UIColor performSelector:selector];
    }
    
    if (color) {
        cell.detailTextLabel.text = [color hexString];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *name = _objects[indexPath.row];
    
    SEL selector = NSSelectorFromString(name);
    UIColor *color = nil;
    if ([UIColor respondsToSelector:selector]) {
        color = [UIColor performSelector:selector];
    }
    
    if (color) {
        cell.backgroundColor = color;
    }

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.detailViewController) {
        self.detailViewController = [[CLDetailViewController alloc] initWithNibName:@"CLDetailViewController" bundle:nil];
    }
    NSDate *object = _objects[indexPath.row];
    self.detailViewController.detailItem = object;
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

@end
