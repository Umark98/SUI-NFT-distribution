module souv::souv_nft {
    use souv::admin::{Self, Admin};  // Import Admin module for permission checks

    /// SOUV NFT structure
    public struct SOUV has key, store {
        id: UID,
        event_id: u64,
        event_name: vector<u8>,
        attendee: address,
    }

    /// Event registry to store registered events (shared object)
    public struct EventRegistry has key {
        id: UID,
        registered_events: vector<u64>,  // List of event IDs
    }

    /// Initialize the EventRegistry (could be called once by deployer)
    public fun init_registry(ctx: &mut TxContext) {
        let registry = EventRegistry {
            id: object::new(ctx),
            registered_events: vector::empty(),
        };
        transfer::share_object(registry);
    }

    /// Register a new event (Admin only)
    public fun register_event(
        admin: &Admin,              // Admin capability for permission
        registry: &mut EventRegistry, // Mutable reference to event registry
        event_id: u64,
        ctx: &TxContext
    ) {
        admin::assert_is_admin(admin, ctx); // Check if sender is admin
        assert!(
            !vector::contains(&registry.registered_events, &event_id),
            1  // Error code 1 for duplicate event
        );
        vector::push_back(&mut registry.registered_events, event_id);
    }

    /// Mint a SOUV NFT for an attendee
    public fun mint_souv(
        registry: &EventRegistry,   // Reference to event registry to check registration
        event_id: u64, 
        event_name: vector<u8>, 
        recipient: address, 
        ctx: &mut TxContext
    ): SOUV {
        // Ensure event is registered (abort happens inside is_event_registered)
        is_event_registered(registry, event_id);  // Will abort if not registered

        // Mint NFT
        SOUV {
            id: object::new(ctx),
            event_id,
            event_name,
            attendee: recipient,
        }
    }

    /// Transfer SOUV NFT to a user
    public fun claim_souv(souv: SOUV, recipient: address) {
        transfer::public_transfer(souv, recipient);
    }

    /// Helper: Check if an event is registered (aborts if not registered)
    public fun is_event_registered(registry: &EventRegistry, event_id: u64): bool {
        if (!vector::contains(&registry.registered_events, &event_id)) {
            abort 2  // Abort with error code 2 if event is not registered
        };
        true
    }
}