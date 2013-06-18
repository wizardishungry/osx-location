// Parsed cmd line options
static int opt_count = 0;


// Program state

static int st_count = 0;

@interface NSObject(CB)
  - (void)logLonLat:(CLLocation*)location;
  - (void)locationManager:(CLLocationManager *)manager
      didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;
  - (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;
@end
