package com.ykapps.earnrewards

import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.Button
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import com.google.android.gms.ads.AdError
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.AdSize
import com.google.android.gms.ads.AdView
import com.google.android.gms.ads.FullScreenContentCallback
import com.google.android.gms.ads.LoadAdError
import com.google.android.gms.ads.MobileAds
import com.google.android.gms.ads.interstitial.InterstitialAd
import com.google.android.gms.ads.interstitial.InterstitialAdLoadCallback
import com.google.android.gms.ads.rewarded.RewardItem
import com.google.android.gms.ads.rewarded.RewardedAd
import com.google.android.gms.ads.rewarded.RewardedAdLoadCallback
import kotlinx.coroutines.launch
import java.text.NumberFormat
import kotlin.math.abs

class MainActivity : AppCompatActivity() {

    private lateinit var bannerAdView: AdView
    private var interstitialAd: InterstitialAd? = null
    private var rewardedAd: RewardedAd? = null

    private lateinit var priceTextView: TextView
    private lateinit var changeTextView: TextView
    private lateinit var statusTextView: TextView
    private lateinit var refreshButton: Button
    private lateinit var interstitialButton: Button
    private lateinit var rewardedButton: Button

    private var isPremiumUnlocked = false

    companion object {
        private const val TAG = "EarnRewards"
        private const val PRICE_UPDATE_INTERVAL = 30000L // 30 seconds
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // Initialize Mobile Ads SDK
        MobileAds.initialize(this) { initializationStatus ->
            Log.d(TAG, "AdMob initialized: ${initializationStatus.description}")
        }

        // Initialize views
        initViews()

        // Setup ads
        setupBannerAd()
        loadInterstitialAd()
        loadRewardedAd()

        // Setup click listeners
        setupClickListeners()

        // Load initial Bitcoin price
        loadBitcoinPrice()
    }

    private fun initViews() {
        priceTextView = findViewById(R.id.priceTextView)
        changeTextView = findViewById(R.id.changeTextView)
        statusTextView = findViewById(R.id.statusTextView)
        refreshButton = findViewById(R.id.refreshButton)
        interstitialButton = findViewById(R.id.interstitialButton)
        rewardedButton = findViewById(R.id.rewardedButton)
    }

    private fun setupBannerAd() {
        bannerAdView = AdView(this).apply {
            setAdSize(AdSize.BANNER)
            adUnitId = getString(R.string.banner_ad_unit_id)
        }

        val bannerContainer = findViewById<android.widget.FrameLayout>(R.id.bannerAdContainer)
        bannerContainer.addView(bannerAdView)

        val adRequest = AdRequest.Builder().build()
        bannerAdView.loadAd(adRequest)

        Log.d(TAG, "Banner ad loaded")
    }

    private fun loadInterstitialAd() {
        val adRequest = AdRequest.Builder().build()

        InterstitialAd.load(
            this,
            getString(R.string.interstitial_ad_unit_id),
            adRequest,
            object : InterstitialAdLoadCallback() {
                override fun onAdLoaded(ad: InterstitialAd) {
                    interstitialAd = ad
                    Log.d(TAG, "Interstitial ad loaded")
                    interstitialButton.isEnabled = true
                }

                override fun onAdFailedToLoad(error: LoadAdError) {
                    Log.e(TAG, "Interstitial ad failed to load: ${error.message}")
                    interstitialButton.isEnabled = false
                }
            }
        )
    }

    private fun loadRewardedAd() {
        val adRequest = AdRequest.Builder().build()

        RewardedAd.load(
            this,
            getString(R.string.rewarded_ad_unit_id),
            adRequest,
            object : RewardedAdLoadCallback() {
                override fun onAdLoaded(ad: RewardedAd) {
                    rewardedAd = ad
                    Log.d(TAG, "Rewarded ad loaded")
                    rewardedButton.isEnabled = true
                }

                override fun onAdFailedToLoad(error: LoadAdError) {
                    Log.e(TAG, "Rewarded ad failed to load: ${error.message}")
                    rewardedButton.isEnabled = false
                }
            }
        )
    }

    private fun setupClickListeners() {
        refreshButton.setOnClickListener {
            loadBitcoinPrice()
            // Show interstitial ad on refresh (good practice for user engagement)
            showInterstitialAd()
        }

        interstitialButton.setOnClickListener {
            showInterstitialAd()
        }

        rewardedButton.setOnClickListener {
            showRewardedAd()
        }
    }

    private fun showInterstitialAd() {
        if (interstitialAd != null) {
            interstitialAd?.fullScreenContentCallback = object : FullScreenContentCallback() {
                override fun onAdDismissedFullScreenContent() {
                    Log.d(TAG, "Interstitial ad dismissed")
                    statusTextView.text = getString(R.string.ad_dismissed)
                    // Reload the ad for next time
                    loadInterstitialAd()
                }

                override fun onAdFailedToShowFullScreenContent(error: AdError) {
                    Log.e(TAG, "Interstitial ad failed to show: ${error.message}")
                    statusTextView.text = getString(R.string.ad_failed)
                    loadInterstitialAd()
                }

                override fun onAdShowedFullScreenContent() {
                    Log.d(TAG, "Interstitial ad shown")
                }
            }

            interstitialAd?.show(this)
            interstitialAd = null
        } else {
            Toast.makeText(this, getString(R.string.ad_not_ready), Toast.LENGTH_SHORT).show()
            statusTextView.text = getString(R.string.ad_not_ready)
        }
    }

    private fun showRewardedAd() {
        if (rewardedAd != null) {
            rewardedAd?.fullScreenContentCallback = object : FullScreenContentCallback() {
                override fun onAdDismissedFullScreenContent() {
                    Log.d(TAG, "Rewarded ad dismissed")
                    // Reload the ad for next time
                    loadRewardedAd()
                }

                override fun onAdFailedToShowFullScreenContent(error: AdError) {
                    Log.e(TAG, "Rewarded ad failed to show: ${error.message}")
                    statusTextView.text = getString(R.string.ad_failed)
                    loadRewardedAd()
                }
            }

            rewardedAd?.show(this) { rewardItem ->
                Log.d(TAG, "Reward earned: ${rewardItem.amount} ${rewardItem.type}")
                onRewardEarned()
            }
            rewardedAd = null
        } else {
            Toast.makeText(this, getString(R.string.ad_not_ready), Toast.LENGTH_SHORT).show()
            statusTextView.text = getString(R.string.ad_not_ready)
        }
    }

    private fun onRewardEarned() {
        isPremiumUnlocked = true
        statusTextView.text = getString(R.string.premium_unlocked)
        Toast.makeText(this, getString(R.string.reward_earned), Toast.LENGTH_LONG).show()
        
        // Unlock premium features (e.g., more frequent price updates)
        priceTextView.setTextColor(getColor(R.color.green))
    }

    private fun loadBitcoinPrice() {
        lifecycleScope.launch {
            try {
                statusTextView.text = getString(R.string.loading)
                
                // Simulated API call - Replace with actual API integration
                val mockPrice = generateMockBitcoinPrice()
                val mockChange = generateMockPriceChange()
                
                val priceFormat = NumberFormat.getCurrencyInstance()
                priceFormat.maximumFractionDigits = 2
                
                priceTextView.text = priceFormat.format(mockPrice)
                
                val changeText = if (mockChange >= 0) "+${mockChange}%" else "${mockChange}%"
                changeTextView.text = changeText
                changeTextView.setTextColor(
                    if (mockChange >= 0) getColor(R.color.green) else getColor(R.color.red)
                )
                
                statusTextView.text = "Last updated: ${java.text.SimpleDateFormat("HH:mm:ss", java.util.Locale.getDefault()).format(java.util.Date())}"
                
            } catch (e: Exception) {
                Log.e(TAG, "Error loading Bitcoin price", e)
                statusTextView.text = getString(R.string.error_loading)
            }
        }
    }

    private fun generateMockBitcoinPrice(): Double {
        // Generate a realistic mock Bitcoin price between $40,000 and $50,000
        return 40000 + (Math.random() * 10000)
    }

    private fun generateMockPriceChange(): Double {
        // Generate a mock price change percentage between -5% and +5%
        return (Math.random() * 10 - 5).let { 
            if (abs(it) < 0.1) 0.1 * (if (it > 0) 1 else -1) else it 
        }
    }

    override fun onPause() {
        bannerAdView.pause()
        super.onPause()
    }

    override fun onResume() {
        super.onResume()
        bannerAdView.resume()
    }

    override fun onDestroy() {
        bannerAdView.destroy()
        super.onDestroy()
    }
}
