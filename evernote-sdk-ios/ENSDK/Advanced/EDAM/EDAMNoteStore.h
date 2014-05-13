/**
 * Autogenerated by Thrift Compiler (0.9.1)
 *
 * DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
 *  @generated
 */

#import <Foundation/Foundation.h>

#import "TProtocol.h"
#import "TException.h"
#import "FATObject.h"
#import "EDAMUserStore.h"
#import "EDAMTypes.h"
#import "EDAMErrors.h"
#import "EDAMLimits.h"

@interface EDAMSyncState : FATObject 
@property (nonatomic, strong) NSNumber * currentTime; // EDAMTimestamp
@property (nonatomic, strong) NSNumber * fullSyncBefore; // EDAMTimestamp
@property (nonatomic, strong) NSNumber * updateCount; // int32_t
@property (nonatomic, strong) NSNumber * uploaded; // int64_t
@property (nonatomic, strong) NSNumber * userLastUpdated; // EDAMTimestamp
@end

@interface EDAMSyncChunk : FATObject 
@property (nonatomic, strong) NSNumber * currentTime; // EDAMTimestamp
@property (nonatomic, strong) NSNumber * chunkHighUSN; // int32_t
@property (nonatomic, strong) NSNumber * updateCount; // int32_t
@property (nonatomic, strong) NSArray * notes;
@property (nonatomic, strong) NSArray * notebooks;
@property (nonatomic, strong) NSArray * tags;
@property (nonatomic, strong) NSArray * searches;
@property (nonatomic, strong) NSArray * resources;
@property (nonatomic, strong) NSArray * expungedNotes;
@property (nonatomic, strong) NSArray * expungedNotebooks;
@property (nonatomic, strong) NSArray * expungedTags;
@property (nonatomic, strong) NSArray * expungedSearches;
@property (nonatomic, strong) NSArray * linkedNotebooks;
@property (nonatomic, strong) NSArray * expungedLinkedNotebooks;
@end

@interface EDAMSyncChunkFilter : FATObject 
@property (nonatomic, strong) NSNumber * includeNotes; // BOOL
@property (nonatomic, strong) NSNumber * includeNoteResources; // BOOL
@property (nonatomic, strong) NSNumber * includeNoteAttributes; // BOOL
@property (nonatomic, strong) NSNumber * includeNotebooks; // BOOL
@property (nonatomic, strong) NSNumber * includeTags; // BOOL
@property (nonatomic, strong) NSNumber * includeSearches; // BOOL
@property (nonatomic, strong) NSNumber * includeResources; // BOOL
@property (nonatomic, strong) NSNumber * includeLinkedNotebooks; // BOOL
@property (nonatomic, strong) NSNumber * includeExpunged; // BOOL
@property (nonatomic, strong) NSNumber * includeNoteApplicationDataFullMap; // BOOL
@property (nonatomic, strong) NSNumber * includeResourceApplicationDataFullMap; // BOOL
@property (nonatomic, strong) NSNumber * includeNoteResourceApplicationDataFullMap; // BOOL
@property (nonatomic, strong) NSString * requireNoteContentClass;
@end

@interface EDAMNoteFilter : FATObject 
@property (nonatomic, strong) NSNumber * order; // int32_t
@property (nonatomic, strong) NSNumber * ascending; // BOOL
@property (nonatomic, strong) NSString * words;
@property (nonatomic, strong) EDAMGuid notebookGuid;
@property (nonatomic, strong) NSArray * tagGuids;
@property (nonatomic, strong) NSString * timeZone;
@property (nonatomic, strong) NSNumber * inactive; // BOOL
@property (nonatomic, strong) NSString * emphasized;
@property (nonatomic, strong) NSNumber * includeAllReadableNotebooks; // BOOL
@end

@interface EDAMNoteList : FATObject 
@property (nonatomic, strong) NSNumber * startIndex; // int32_t
@property (nonatomic, strong) NSNumber * totalNotes; // int32_t
@property (nonatomic, strong) NSArray * notes;
@property (nonatomic, strong) NSArray * stoppedWords;
@property (nonatomic, strong) NSArray * searchedWords;
@property (nonatomic, strong) NSNumber * updateCount; // int32_t
@end

@interface EDAMNoteMetadata : FATObject 
@property (nonatomic, strong) EDAMGuid guid;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSNumber * contentLength; // int32_t
@property (nonatomic, strong) NSNumber * created; // EDAMTimestamp
@property (nonatomic, strong) NSNumber * updated; // EDAMTimestamp
@property (nonatomic, strong) NSNumber * deleted; // EDAMTimestamp
@property (nonatomic, strong) NSNumber * updateSequenceNum; // int32_t
@property (nonatomic, strong) NSString * notebookGuid;
@property (nonatomic, strong) NSArray * tagGuids;
@property (nonatomic, strong) EDAMNoteAttributes * attributes;
@property (nonatomic, strong) NSString * largestResourceMime;
@property (nonatomic, strong) NSNumber * largestResourceSize; // int32_t
@end

@interface EDAMNotesMetadataList : FATObject 
@property (nonatomic, strong) NSNumber * startIndex; // int32_t
@property (nonatomic, strong) NSNumber * totalNotes; // int32_t
@property (nonatomic, strong) NSArray * notes;
@property (nonatomic, strong) NSArray * stoppedWords;
@property (nonatomic, strong) NSArray * searchedWords;
@property (nonatomic, strong) NSNumber * updateCount; // int32_t
@end

@interface EDAMNotesMetadataResultSpec : FATObject 
@property (nonatomic, strong) NSNumber * includeTitle; // BOOL
@property (nonatomic, strong) NSNumber * includeContentLength; // BOOL
@property (nonatomic, strong) NSNumber * includeCreated; // BOOL
@property (nonatomic, strong) NSNumber * includeUpdated; // BOOL
@property (nonatomic, strong) NSNumber * includeDeleted; // BOOL
@property (nonatomic, strong) NSNumber * includeUpdateSequenceNum; // BOOL
@property (nonatomic, strong) NSNumber * includeNotebookGuid; // BOOL
@property (nonatomic, strong) NSNumber * includeTagGuids; // BOOL
@property (nonatomic, strong) NSNumber * includeAttributes; // BOOL
@property (nonatomic, strong) NSNumber * includeLargestResourceMime; // BOOL
@property (nonatomic, strong) NSNumber * includeLargestResourceSize; // BOOL
@end

@interface EDAMNoteCollectionCounts : FATObject 
@property (nonatomic, strong) NSDictionary * notebookCounts;
@property (nonatomic, strong) NSDictionary * tagCounts;
@property (nonatomic, strong) NSNumber * trashCount; // int32_t
@end

@interface EDAMNoteEmailParameters : FATObject 
@property (nonatomic, strong) NSString * guid;
@property (nonatomic, strong) EDAMNote * note;
@property (nonatomic, strong) NSArray * toAddresses;
@property (nonatomic, strong) NSArray * ccAddresses;
@property (nonatomic, strong) NSString * subject;
@property (nonatomic, strong) NSString * message;
@end

@interface EDAMNoteVersionId : FATObject 
@property (nonatomic, strong) NSNumber * updateSequenceNum; // int32_t
@property (nonatomic, strong) NSNumber * updated; // EDAMTimestamp
@property (nonatomic, strong) NSNumber * saved; // EDAMTimestamp
@property (nonatomic, strong) NSString * title;
@end

@interface EDAMClientUsageMetrics : FATObject 
@property (nonatomic, strong) NSNumber * sessions; // int32_t
@end

@interface EDAMRelatedQuery : FATObject 
@property (nonatomic, strong) NSString * noteGuid;
@property (nonatomic, strong) NSString * plainText;
@property (nonatomic, strong) EDAMNoteFilter * filter;
@property (nonatomic, strong) NSString * referenceUri;
@end

@interface EDAMRelatedResult : FATObject 
@property (nonatomic, strong) NSArray * notes;
@property (nonatomic, strong) NSArray * notebooks;
@property (nonatomic, strong) NSArray * tags;
@property (nonatomic, strong) NSArray * containingNotebooks;
@property (nonatomic, strong) NSArray * experts;
@end

@interface EDAMRelatedResultSpec : FATObject 
@property (nonatomic, strong) NSNumber * maxNotes; // int32_t
@property (nonatomic, strong) NSNumber * maxNotebooks; // int32_t
@property (nonatomic, strong) NSNumber * maxTags; // int32_t
@property (nonatomic, strong) NSNumber * writableNotebooksOnly; // BOOL
@property (nonatomic, strong) NSNumber * includeContainingNotebooks; // BOOL
@property (nonatomic, strong) NSNumber * maxExperts; // int32_t
@end

@interface EDAMBusinessQuery : FATObject 
@property (nonatomic, strong) EDAMNoteFilter * filter;
@property (nonatomic, strong) NSNumber * numExperts; // int32_t
@property (nonatomic, strong) NSNumber * includeNotebooks; // BOOL
@property (nonatomic, strong) NSNumber * includeNotesCounts; // BOOL
@end

@interface EDAMBusinessQueryResult : FATObject 
@property (nonatomic, strong) NSNumber * totalNotebooks; // int32_t
@property (nonatomic, strong) NSDictionary * totalNotesByNotebook;
@property (nonatomic, strong) NSArray * experts;
@property (nonatomic, strong) NSArray * matchingNotebooks;
@end

@protocol EDAMNoteStore <NSObject>
- (EDAMSyncState *) getSyncState: (NSString *) authenticationToken;  // throws EDAMUserException *, EDAMSystemException *, TException
- (EDAMSyncState *) getSyncStateWithMetrics: (NSString *) authenticationToken clientMetrics: (EDAMClientUsageMetrics *) clientMetrics;  // throws EDAMUserException *, EDAMSystemException *, TException
- (EDAMSyncChunk *) getSyncChunk: (NSString *) authenticationToken afterUSN: (int32_t) afterUSN maxEntries: (int32_t) maxEntries fullSyncOnly: (BOOL) fullSyncOnly;  // throws EDAMUserException *, EDAMSystemException *, TException
- (EDAMSyncChunk *) getFilteredSyncChunk: (NSString *) authenticationToken afterUSN: (int32_t) afterUSN maxEntries: (int32_t) maxEntries filter: (EDAMSyncChunkFilter *) filter;  // throws EDAMUserException *, EDAMSystemException *, TException
- (EDAMSyncState *) getLinkedNotebookSyncState: (NSString *) authenticationToken linkedNotebook: (EDAMLinkedNotebook *) linkedNotebook;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (EDAMSyncChunk *) getLinkedNotebookSyncChunk: (NSString *) authenticationToken linkedNotebook: (EDAMLinkedNotebook *) linkedNotebook afterUSN: (int32_t) afterUSN maxEntries: (int32_t) maxEntries fullSyncOnly: (BOOL) fullSyncOnly;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (NSArray *) listNotebooks: (NSString *) authenticationToken;  // throws EDAMUserException *, EDAMSystemException *, TException
- (NSArray *) listPublishedBusinessNotebooks: (NSString *) authenticationToken;  // throws EDAMUserException *, EDAMSystemException *, TException
- (EDAMNotebook *) getNotebook: (NSString *) authenticationToken guid: (EDAMGuid) guid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (EDAMNotebook *) getDefaultNotebook: (NSString *) authenticationToken;  // throws EDAMUserException *, EDAMSystemException *, TException
- (EDAMNotebook *) createNotebook: (NSString *) authenticationToken notebook: (EDAMNotebook *) notebook;  // throws EDAMUserException *, EDAMSystemException *, TException
- (int32_t) updateNotebook: (NSString *) authenticationToken notebook: (EDAMNotebook *) notebook;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (int32_t) expungeNotebook: (NSString *) authenticationToken guid: (EDAMGuid) guid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (NSArray *) listTags: (NSString *) authenticationToken;  // throws EDAMUserException *, EDAMSystemException *, TException
- (NSArray *) listTagsByNotebook: (NSString *) authenticationToken notebookGuid: (EDAMGuid) notebookGuid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (EDAMTag *) getTag: (NSString *) authenticationToken guid: (EDAMGuid) guid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (EDAMTag *) createTag: (NSString *) authenticationToken tag: (EDAMTag *) tag;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (int32_t) updateTag: (NSString *) authenticationToken tag: (EDAMTag *) tag;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (void) untagAll: (NSString *) authenticationToken guid: (EDAMGuid) guid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (int32_t) expungeTag: (NSString *) authenticationToken guid: (EDAMGuid) guid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (NSArray *) listSearches: (NSString *) authenticationToken;  // throws EDAMUserException *, EDAMSystemException *, TException
- (EDAMSavedSearch *) getSearch: (NSString *) authenticationToken guid: (EDAMGuid) guid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (EDAMSavedSearch *) createSearch: (NSString *) authenticationToken search: (EDAMSavedSearch *) search;  // throws EDAMUserException *, EDAMSystemException *, TException
- (int32_t) updateSearch: (NSString *) authenticationToken search: (EDAMSavedSearch *) search;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (int32_t) expungeSearch: (NSString *) authenticationToken guid: (EDAMGuid) guid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (EDAMNoteList *) findNotes: (NSString *) authenticationToken filter: (EDAMNoteFilter *) filter offset: (int32_t) offset maxNotes: (int32_t) maxNotes;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (int32_t) findNoteOffset: (NSString *) authenticationToken filter: (EDAMNoteFilter *) filter guid: (EDAMGuid) guid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (EDAMNotesMetadataList *) findNotesMetadata: (NSString *) authenticationToken filter: (EDAMNoteFilter *) filter offset: (int32_t) offset maxNotes: (int32_t) maxNotes resultSpec: (EDAMNotesMetadataResultSpec *) resultSpec;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (EDAMNoteCollectionCounts *) findNoteCounts: (NSString *) authenticationToken filter: (EDAMNoteFilter *) filter withTrash: (BOOL) withTrash;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (EDAMNote *) getNote: (NSString *) authenticationToken guid: (EDAMGuid) guid withContent: (BOOL) withContent withResourcesData: (BOOL) withResourcesData withResourcesRecognition: (BOOL) withResourcesRecognition withResourcesAlternateData: (BOOL) withResourcesAlternateData;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (EDAMLazyMap *) getNoteApplicationData: (NSString *) authenticationToken guid: (EDAMGuid) guid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (NSString *) getNoteApplicationDataEntry: (NSString *) authenticationToken guid: (EDAMGuid) guid key: (NSString *) key;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (int32_t) setNoteApplicationDataEntry: (NSString *) authenticationToken guid: (EDAMGuid) guid key: (NSString *) key value: (NSString *) value;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (int32_t) unsetNoteApplicationDataEntry: (NSString *) authenticationToken guid: (EDAMGuid) guid key: (NSString *) key;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (NSString *) getNoteContent: (NSString *) authenticationToken guid: (EDAMGuid) guid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (NSString *) getNoteSearchText: (NSString *) authenticationToken guid: (EDAMGuid) guid noteOnly: (BOOL) noteOnly tokenizeForIndexing: (BOOL) tokenizeForIndexing;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (NSString *) getResourceSearchText: (NSString *) authenticationToken guid: (EDAMGuid) guid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (NSArray *) getNoteTagNames: (NSString *) authenticationToken guid: (EDAMGuid) guid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (EDAMNote *) createNote: (NSString *) authenticationToken note: (EDAMNote *) note;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (EDAMNote *) updateNote: (NSString *) authenticationToken note: (EDAMNote *) note;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (int32_t) deleteNote: (NSString *) authenticationToken guid: (EDAMGuid) guid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (int32_t) expungeNote: (NSString *) authenticationToken guid: (EDAMGuid) guid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (int32_t) expungeNotes: (NSString *) authenticationToken noteGuids: (NSArray *) noteGuids;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (int32_t) expungeInactiveNotes: (NSString *) authenticationToken;  // throws EDAMUserException *, EDAMSystemException *, TException
- (EDAMNote *) copyNote: (NSString *) authenticationToken noteGuid: (EDAMGuid) noteGuid toNotebookGuid: (EDAMGuid) toNotebookGuid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (NSArray *) listNoteVersions: (NSString *) authenticationToken noteGuid: (EDAMGuid) noteGuid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (EDAMNote *) getNoteVersion: (NSString *) authenticationToken noteGuid: (EDAMGuid) noteGuid updateSequenceNum: (int32_t) updateSequenceNum withResourcesData: (BOOL) withResourcesData withResourcesRecognition: (BOOL) withResourcesRecognition withResourcesAlternateData: (BOOL) withResourcesAlternateData;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (EDAMResource *) getResource: (NSString *) authenticationToken guid: (EDAMGuid) guid withData: (BOOL) withData withRecognition: (BOOL) withRecognition withAttributes: (BOOL) withAttributes withAlternateData: (BOOL) withAlternateData;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (EDAMLazyMap *) getResourceApplicationData: (NSString *) authenticationToken guid: (EDAMGuid) guid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (NSString *) getResourceApplicationDataEntry: (NSString *) authenticationToken guid: (EDAMGuid) guid key: (NSString *) key;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (int32_t) setResourceApplicationDataEntry: (NSString *) authenticationToken guid: (EDAMGuid) guid key: (NSString *) key value: (NSString *) value;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (int32_t) unsetResourceApplicationDataEntry: (NSString *) authenticationToken guid: (EDAMGuid) guid key: (NSString *) key;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (int32_t) updateResource: (NSString *) authenticationToken resource: (EDAMResource *) resource;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (NSData *) getResourceData: (NSString *) authenticationToken guid: (EDAMGuid) guid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (EDAMResource *) getResourceByHash: (NSString *) authenticationToken noteGuid: (EDAMGuid) noteGuid contentHash: (NSData *) contentHash withData: (BOOL) withData withRecognition: (BOOL) withRecognition withAlternateData: (BOOL) withAlternateData;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (NSData *) getResourceRecognition: (NSString *) authenticationToken guid: (EDAMGuid) guid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (NSData *) getResourceAlternateData: (NSString *) authenticationToken guid: (EDAMGuid) guid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (EDAMResourceAttributes *) getResourceAttributes: (NSString *) authenticationToken guid: (EDAMGuid) guid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (EDAMNotebook *) getPublicNotebook: (EDAMUserID) userId publicUri: (NSString *) publicUri;  // throws EDAMSystemException *, EDAMNotFoundException *, TException
- (EDAMSharedNotebook *) createSharedNotebook: (NSString *) authenticationToken sharedNotebook: (EDAMSharedNotebook *) sharedNotebook;  // throws EDAMUserException *, EDAMNotFoundException *, EDAMSystemException *, TException
- (EDAMSharedNotebook *) shareNotebook: (NSString *) authenticationToken sharedNotebook: (EDAMSharedNotebook *) sharedNotebook message: (NSString *) message;  // throws EDAMUserException *, EDAMNotFoundException *, EDAMSystemException *, TException
- (int32_t) updateSharedNotebook: (NSString *) authenticationToken sharedNotebook: (EDAMSharedNotebook *) sharedNotebook;  // throws EDAMUserException *, EDAMNotFoundException *, EDAMSystemException *, TException
- (int32_t) setSharedNotebookRecipientSettings: (NSString *) authenticationToken sharedNotebookId: (int64_t) sharedNotebookId recipientSettings: (EDAMSharedNotebookRecipientSettings *) recipientSettings;  // throws EDAMUserException *, EDAMNotFoundException *, EDAMSystemException *, TException
- (int32_t) sendMessageToSharedNotebookMembers: (NSString *) authenticationToken notebookGuid: (EDAMGuid) notebookGuid messageText: (NSString *) messageText recipients: (NSArray *) recipients;  // throws EDAMUserException *, EDAMNotFoundException *, EDAMSystemException *, TException
- (NSArray *) listSharedNotebooks: (NSString *) authenticationToken;  // throws EDAMUserException *, EDAMNotFoundException *, EDAMSystemException *, TException
- (int32_t) expungeSharedNotebooks: (NSString *) authenticationToken sharedNotebookIds: (NSArray *) sharedNotebookIds;  // throws EDAMUserException *, EDAMNotFoundException *, EDAMSystemException *, TException
- (EDAMLinkedNotebook *) createLinkedNotebook: (NSString *) authenticationToken linkedNotebook: (EDAMLinkedNotebook *) linkedNotebook;  // throws EDAMUserException *, EDAMNotFoundException *, EDAMSystemException *, TException
- (int32_t) updateLinkedNotebook: (NSString *) authenticationToken linkedNotebook: (EDAMLinkedNotebook *) linkedNotebook;  // throws EDAMUserException *, EDAMNotFoundException *, EDAMSystemException *, TException
- (NSArray *) listLinkedNotebooks: (NSString *) authenticationToken;  // throws EDAMUserException *, EDAMNotFoundException *, EDAMSystemException *, TException
- (int32_t) expungeLinkedNotebook: (NSString *) authenticationToken guid: (EDAMGuid) guid;  // throws EDAMUserException *, EDAMNotFoundException *, EDAMSystemException *, TException
- (EDAMAuthenticationResult *) authenticateToSharedNotebook: (NSString *) shareKeyOrGlobalId authenticationToken: (NSString *) authenticationToken;  // throws EDAMUserException *, EDAMNotFoundException *, EDAMSystemException *, TException
- (EDAMSharedNotebook *) getSharedNotebookByAuth: (NSString *) authenticationToken;  // throws EDAMUserException *, EDAMNotFoundException *, EDAMSystemException *, TException
- (void) emailNote: (NSString *) authenticationToken parameters: (EDAMNoteEmailParameters *) parameters;  // throws EDAMUserException *, EDAMNotFoundException *, EDAMSystemException *, TException
- (NSString *) shareNote: (NSString *) authenticationToken guid: (EDAMGuid) guid;  // throws EDAMUserException *, EDAMNotFoundException *, EDAMSystemException *, TException
- (void) stopSharingNote: (NSString *) authenticationToken guid: (EDAMGuid) guid;  // throws EDAMUserException *, EDAMNotFoundException *, EDAMSystemException *, TException
- (EDAMAuthenticationResult *) authenticateToSharedNote: (NSString *) guid noteKey: (NSString *) noteKey authenticationToken: (NSString *) authenticationToken;  // throws EDAMUserException *, EDAMNotFoundException *, EDAMSystemException *, TException
- (EDAMRelatedResult *) findRelated: (NSString *) authenticationToken query: (EDAMRelatedQuery *) query resultSpec: (EDAMRelatedResultSpec *) resultSpec;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (EDAMBusinessQueryResult *) findInBusiness: (NSString *) authenticationToken query: (EDAMBusinessQuery *) query;  // throws EDAMUserException *, EDAMSystemException *, TException
@end

// !!! The inProtocol and outProtocol getters are manual additions to the autogenerated file. These allow owners to hook the protocols
// and add upload/download progress to them. All that's been added is the accessor declarations and trivial implementation. -BZ.
@interface EDAMNoteStoreClient : NSObject <EDAMNoteStore> 
- (id) initWithProtocol: (id <TProtocol>) protocol;
- (id) initWithInProtocol: (id <TProtocol>) inProtocol outProtocol: (id <TProtocol>) outProtocol;
- (id<TProtocol>)inProtocol;
- (id<TProtocol>)outProtocol;
@end

@interface EDAMNoteStoreConstants : NSObject 
@end
