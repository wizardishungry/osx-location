#import <cocoa/cocoa.h>
#import <CoreLocation/CoreLocation.h>
#import "location.h"

@implementation NSObject(CB)
  - (void)logLonLat:(CLLocation*)location
  {
      CLLocationCoordinate2D coordinate = location.coordinate;
      NSLog(@"latitude,logitude : %f, %f", coordinate.latitude, coordinate.longitude);
      NSLog(@"timestamp         : %@", location.timestamp);
      if(++st_count>=opt_count)
        exit(0);
  }

  - (void)locationManager:(CLLocationManager *)manager
      didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
      NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
      [self logLonLat:newLocation];
      [pool drain];
  }

  - (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
      NSLog(@"Error: %@", error);
  }
@end


void showHelp(void) {
    printf(
"--count <number>         Wait for this many responses (default: 1).\n"
"--help                   Show this help.\n"
"\n"
    );
}

void parseArgs(int argc, char*argv[])
{
  int j;
  /* Parse the command line options
   * Stolen from https://github.com/antirez/dump1090/blob/master/dump1090.c
   */
  for (j = 1; j < argc; j++) {
    int more = j+1 < argc; /* There are more arguments. */

    if (!strcmp(argv[j],"--count") && more) {
      opt_count = atoi(argv[++j]);
    } else if (!strcmp(argv[j],"--help")) {
      showHelp();
      exit(0);
    } else {
      fprintf(stderr,
  "Unknown or not enough arguments for option '%s'.\n\n",
  argv[j]);
      showHelp();
      exit(1);
    }
  }
}

int main(int ac,char *av[])
{
  parseArgs(ac, av);
  id obj = [[NSObject alloc] init];
  id lm = nil;
  if ([CLLocationManager locationServicesEnabled]) {
    printf("location service enabled\n");
    lm = [[CLLocationManager alloc] init];
    [lm setDelegate:obj];
    [lm startUpdatingLocation];
  }
  else {
    printf("location service disabled\n");
    return 1;
  }

  CFRunLoopRun();
  [lm release];
  [obj release];
  return 0;
}
