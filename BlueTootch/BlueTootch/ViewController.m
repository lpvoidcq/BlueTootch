//
//  ViewController.m
//  BlueTootch
//
//  Created by caoquan on 16/6/30.
//  Copyright © 2016年 caoquan. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController ()<CBCentralManagerDelegate>
@property (nonatomic, strong) CBCentralManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber  numberWithBool:YES], CBCentralManagerScanOptionAllowDuplicatesKey, nil];
    
    [_manager scanForPeripheralsWithServices:nil options:options];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)centralManagerDidUpdateState:(CBCentralManager *)central {

}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    if([peripheral.name  isEqualToString:@""]){
        [self connect:peripheral];
    }
}

-(BOOL)connect:(CBPeripheral *)peripheral{
    self.manager.delegate = self;
    [self.manager connectPeripheral:peripheral
                            options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
    return YES;
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    
    NSLog(@"Did connect to peripheral: %@", peripheral);
//    _testPeripheral = peripheral;
    
    [peripheral setDelegate:self]; //查找服务
    [peripheral discoverServices:nil];
    
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    
    
    NSLog(@"didDiscoverServices");
    
//    if (error)
//    {
//        NSLog(@"Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
//        
//        if ([self.delegate respondsToSelector:@selector(DidNotifyFailConnectService:withPeripheral:error:)])
//            [self.delegate DidNotifyFailConnectService:nil withPeripheral:nil error:nil];
//        
//        return;
//    }
    
    
    for (CBService *service in peripheral.services)
    {
        //发现服务
        if ([service.UUID isEqual:[CBUUID UUIDWithString:@""]])
        {
            NSLog(@"Service found with UUID: %@", service.UUID);  //查找特征
            [peripheral discoverCharacteristics:nil forService:service];
            break;
        }
        
        
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
    if (error)
    {
        NSLog(@"Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
        
//        [self error];
        return;
    }
    
    NSLog(@"服务：%@",service.UUID);
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        //发现特征
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"xxxxxxx"]]) {
            NSLog(@"监听：%@",characteristic);//监听特征
//            [self.peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
        
    }
}
@end
