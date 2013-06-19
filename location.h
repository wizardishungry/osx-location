// Parsed cmd line options
static int opt_count = 0;


// Program state

int st_count   = 0;
int st_debug   = 0;
char st_format = 'k';

@interface NSObject(CB)
  - (void)logLonLat:(CLLocation*)location;
  - (void)locationManager:(CLLocationManager *)manager
      didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;
  - (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;
@end

// function declarations
extern void QuietLog (FILE *, NSString *format, ...); // http://cocoaheads.byu.edu/wiki/different-nslog
#define QuietDebug(...) QuietLog (stderr, __VA_ARGS__)
#define QuietError(...) QuietLog (stderr, __VA_ARGS__)
#define printf(...) QuietLog(stdout, __VA_ARGS__)
