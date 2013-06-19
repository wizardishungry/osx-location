#import <cocoa/cocoa.h>
#import <CoreLocation/CoreLocation.h>
#import "location.h"

@implementation NSObject(CB)
  - (void)logLonLat:(CLLocation*)location
  {
      CLLocationCoordinate2D coordinate = location.coordinate;
      QuietDebug ([location description]);
      QuietDebug (@"\n");

      switch(st_format) {
        case 'k':
                printf(@"timestamp: %@\n", location.timestamp);
                printf(@"latitude,longitude: %f,%f\n", coordinate.latitude, coordinate.longitude);
                printf(@"altitude: %f\n", location.altitude);
                printf(@"horizontalAccuracy: %f\n", location.horizontalAccuracy);
                printf(@"verticalAccuracy: %f\n", location.verticalAccuracy);
                printf(@"speed: %f\n", location.speed);
                printf(@"course: %f\n", location.course);
                break;
        case 'j':
                QuietError(@"unimplemented");
        default:
          QuietError(@"Format %c invalid\n", st_format);
      }

      updateCount();
  }

  - (void)locationManager:(CLLocationManager *)manager
      didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
      NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
      [self logLonLat:newLocation];
      [pool drain];
  }

  - (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
      QuietError(@"Error: %@", error);
      updateCount();
  }
@end

void updateCount()
{
  if(++st_count>=opt_count)
    exit(0); // todo finalize output
}

int QuietLog (FILE *stream, NSString *format, ...)
{
    if (format == nil) {
        fprintf(stream, "nil\n");
        return -1;
    }
    // Get a reference to the arguments that follow the format parameter
    va_list argList;
    va_start(argList, format);
    // Perform format string argument substitution, reinstate %% escapes, then print
    NSString *s = [[NSString alloc] initWithFormat:format arguments:argList];
    fprintf(stream, "%s", [[s stringByReplacingOccurrencesOfString:@"%%" withString:@"%%%%"] UTF8String]);
    [s release];
    va_end(argList);
    return 0;
}

void showHelp(void)
{
    printf(
@"--count <number>         Wait for this many responses (default: 1).\n"
@"--debug                  Output helpful debugging info.\n"
@"--format <format>        Set the output format (default: key-value).\n"
@"--help                   Show this help.\n"
@"Formats available:\n"
@"                      k = key-value\n"
@"                      j = Geo JSON\n" // http://www.geojson.org
@"                      s = SBS-1 ADS-B\n" // Vroom!
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
    } else if (!strcmp(argv[j],"--debug")) {
      st_debug = 1;
    } else if (!strcmp(argv[j],"--format") && more) {
      st_format = *argv[++j];
    } else if (!strcmp(argv[j],"--help")) {
      showHelp();
      exit(0);
    } else {
      QuietError(
        @"Unknown or not enough arguments for option '%s'.\n\n",
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
    QuietDebug(@"location service enabled\n");
    lm = [[CLLocationManager alloc] init];
    [lm setDelegate:obj];
    [lm startUpdatingLocation];
  }
  else {
    QuietDebug(@"location service disabled\n");
    return 1;
  }

  CFRunLoopRun();
  [lm release];
  [obj release];
  return 0;
}
