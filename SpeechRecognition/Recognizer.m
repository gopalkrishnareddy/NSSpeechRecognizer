#import <Foundation/Foundation.h>
@import AppKit;

#import "Recognizer.h"

////////////////////////////////////////////////////////////////////////////////

/*
 
NSArray<NSString*>*_  ~  char*_[]
 
 */
//NSArray<NSString*>* toNSStringArray(const char* _strings[]) { //TODO in haskell
//    NSArray<NSString*>* strings = _strings;
//    return strings;
//}

//const char** fromNSStringArray(NSArray<NSString*>* _strings) {
//    const char** strings = _strings;
//    return strings;
//}

//NSString* fromUTF8(const char* s) {
//    return [NSString stringWithCString:s encoding:NSUTF8StringEncoding];
//}

void fromUTF8(const char* c, NSString* ns) {
    ns = [NSString stringWithCString:c encoding:NSUTF8StringEncoding];
}

const char* toUTF8(NSString* s) {
    return [s cStringUsingEncoding:NSUTF8StringEncoding];
}

int length(void* a[]) {
    int i = 0;
    while (a[i] != NULL) {
        i++;
    }
    return i;
}

////////////////////////////////////////////////////////////////////////////////

@implementation Recognizer

- (id) init {
    if (self = [super init]) {
        self.recognizer = [NSSpeechRecognizer new];
        self.recognizer.listensInForegroundOnly = NO;
        self.recognizer.blocksOtherRecognizers  = NO;
        self.recognizer.delegate                = self;
        self.recognizer.commands                = @[];
        
        self.handler = 0; //NOTE unsafe
    }
    
    return self;
}

//
- (void) speechRecognizer:(NSSpeechRecognizer *)recognizer didRecognizeCommand:(NSString*) _recognition {
//    NSLog(@"RECOGNIZED: %@", _recognition);
    const char* recognition = [_recognition cStringUsingEncoding:NSUTF8StringEncoding];
    self.handler(recognition);
}

@end

////////////////////////////////////////////////////////////////////////////////
// self is a keyword

Recognizer* new_NSSpeechRecognizer(){
    return [Recognizer new];
}

void free_NSSpeechRecognizer(Recognizer* this) { //TODO
    [this.recognizer.commands release];
    [this.recognizer release];
    [this release];
}

void start_NSSpeechRecognizer(Recognizer* this) {
    [this.recognizer startListening];
}

void stop_NSSpeechRecognizer(Recognizer* this) {
    [this.recognizer stopListening];
}

// const char* _[] is an array of strings
void setCommands_NSSpeechRecognizer(Recognizer* this, const char* givenCommands[], int length){
    NSArray<NSString*>* ns_array_of_ns_strings;
    NSString*            c_array_of_ns_strings[length];

    NSString*  ns_string;
    const char* c_string;
 
    for (int i = 0; i < length; i++) {
        c_string = givenCommands[i];
        ns_string = [NSString stringWithCString:c_string encoding:NSUTF8StringEncoding];
        c_array_of_ns_strings[i] = ns_string;
    }
    
    ns_array_of_ns_strings = [NSArray arrayWithObjects:c_array_of_ns_strings count:(NSUInteger)length];
    
    this.recognizer.commands = ns_array_of_ns_strings;
}

void setHandler_NSSpeechRecognizer(Recognizer* this, void(*handler)(const char*)){
    this.handler = handler;
}

////////////////////////////////////////////////////////////////////////////////