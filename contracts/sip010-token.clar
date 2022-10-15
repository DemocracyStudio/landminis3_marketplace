
;; sip010-token
;; create a ft using sip010 standard from stacks

;; Asserting explicit conformity with the trait
(impl-trait .sip010-ft-trait.sip010-ft-trait)

;; deploy SIP010 trait on mainnet
;; (impl-trait 'SP3FBR2AGK5H9QBDH3EEN6DF8EK8JY7RX8QJ5SVTE.sip-010-trait-ft-standard.sip-010-trait)

;; constants
;;
;; constant for the contract deployer
(define-constant contract-owner tx-sender)
;; two error codes
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))

;; data maps and vars
;; token definition with no maximum supply
(define-fungible-token atx-coin)
;; token definition with a maximum of 1,000,000 tokens.
;;(define-fungible-token atx-coin u1000000)

;; private functions
;;

;; public functions
;;

;; transfer function asserts that sender == tx-sender, unwrap and print memo
(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
    (begin 
        (asserts! (is-eq tx-sender sender) err-owner-only)
        (try! (ft-transfer? atx-coin amount sender recipient))
        (match memo to-print (print to-print) 0x)
        (ok true)
    )
)

;; static function that returns a human-readable name for our token
(define-read-only (get-name) 
    (ok "Atx Coin")
)

;; static function that returns a human-readeable symbol for our token
(define-read-only (get-symbol)
    (ok "ATC")
)

;; static function to display the number of decimals
(define-read-only (get-decimals) 
    (ok u6)
)

;; wraps the built-in function to retrieve the balance of a specified principal
(define-read-only (get-balance (who principal))
    (ok (ft-get-balance atx-coin who))
)

;; returns the total supply of a custom token
(define-read-only (get-total-supply) 
    (ok (ft-get-supply atx-coin))
)

;; return a link to metadata of the token
(define-read-only (get-token-uri) 
(ok none)
)

;; mint new tokens that only the contract deployer can call
(define-public (mint (amount uint) (recipient principal))
    (begin 
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (ft-mint? atx-coin amount recipient)
    )
)
